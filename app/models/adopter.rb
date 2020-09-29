#    Copyright 2017 Operation Paws for Homes
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

# == Schema Information
#
# Table name: adopters
#
#  id                  :integer          not null, primary key
#  name                :string
#  email               :string
#  phone               :string
#  address1            :string
#  address2            :string
#  city                :string
#  state               :string
#  zip                 :string
#  status              :string
#  when_to_call        :string
#  created_at          :datetime
#  updated_at          :datetime
#  dog_or_cat          :string
#  dog_reqs            :text
#  why_adopt           :text
#  dog_name            :string
#  other_phone         :string
#  assigned_to_user_id :integer
#  flag                :string
#  is_subscribed       :boolean          default(FALSE)
#  completed_date      :date
#  county              :string
#  training_email_sent :boolean          default(FALSE), not null
#

class Adopter < ApplicationRecord
  audited on: :update
  has_associated_audits

  attr_accessor :pre_q_abuse,
                :pre_q_dog_adjust,
                :pre_q_limited_info,
                :pre_q_breed_info,
                :pre_q_hold,
                :pre_q_costs

  attr_reader :dog_tokens
  attr_accessor :updated_by_admin_user

  STATUSES = ['new',
              'pend response',
              'workup',
              'ready for final',
              'approved',
              'adopted',
              'adptd sn pend',
              'completed',
              'returned',
              'standby',
              'withdrawn',
              'denied']

  FLAGS = ['High', 'Low', 'On Hold']

  has_many :references, dependent: :destroy
  accepts_nested_attributes_for :references

  has_many :adoptions, dependent: :destroy
  accepts_nested_attributes_for :adoptions

  has_many :cat_adoptions, dependent: :destroy
  accepts_nested_attributes_for :cat_adoptions

  has_one :adoption_app, dependent: :destroy
  accepts_nested_attributes_for :adoption_app

  has_many :dogs, through: :adoptions
  has_many :cats, through: :cat_adoptions
  has_many :comments, -> { order('created_at DESC') }, as: :commentable

  belongs_to :user, class_name: 'User', primary_key: 'id', foreign_key: 'assigned_to_user_id'

  validates :name, presence: true, length: { maximum: 50 }
  validates :phone, presence: true, length: { in: 10..25 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :secondary_email, allow_blank: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :address1, presence: true, length: { maximum: 255 }
  validates :address2, allow_blank: true, length: { maximum: 255 }
  validates :city, presence: true, length: { maximum: 255 }
  validates :state, presence: true, length: { is: 2 }
  validates :zip, presence: true, length: { in: 5..10 }
  validates :when_to_call, allow_blank: true, length: { maximum: 255 }
  validates :dog_name, allow_blank: true, length: { maximum: 255 }
  validates :other_phone, allow_blank: true, length: { maximum: 255 }

  validates_presence_of :status
  validates_inclusion_of :status, in: STATUSES

  before_create :chimp_subscribe
  before_update :chimp_check
  before_save :populate_county

  def populate_county
    return unless zip_changed?

    self.county = CountyService.fetch(zip)
  end

  def dog_tokens=(ids)
    self.dog_ids = ids.split(',')
  end

  def attributes_to_audit
    %w[status assigned_to_user_id email phone address1 address2 city state zip]
  end

  def audits_and_associated_audits
    (audits + associated_audits).sort_by(&:created_at).reverse!
  end

  def changes_to_sentence
    result = []
    changed_audit_attributes.each do |attr|
      if attr == 'assigned_to_user_id'
        new_value = user.present? ? user.name : 'No One'
        result << "assigned application to #{new_value}"
      else
        old_value = send("#{attr}_was")
        new_value = send(attr)
        result << "changed #{attr} from #{old_value} to #{new_value}"
      end
    end

    result.sort.join(' * ')
  end

  def chimp_subscribe
    if (status == 'adopted') || (status == 'completed') || (status == 'adptd sn pend')
      if (status != 'completed')
        completed_date = Time.now.strftime('%m/%d/%Y')
      else
        completed_date = ''
      end
      interests = {
        adopted_from_oph: true,
        active_application: false
      }
    else
      interests = {
        adopted_from_oph: false,
        active_application: true
      }
    end

    merge_vars = {
      'FNAME' => name,
      'MMERGE2' => status,
      'MMERGE3' => completed_date
    }
    AdopterSubscribeJob.perform_later(email, merge_vars, interests)
    self.is_subscribed = true
  end

  def comments_and_audits_and_associated_audits
    (persisted_comments + audits + associated_audits).sort_by(&:created_at).reverse!
  end

  def chimp_check
    return unless status_changed?

    if (status == 'denied') && is_subscribed?
      chimp_unsubscribe
    else
      chimp_subscribe
    end
  end

  def chimp_unsubscribe
    AdopterUnsubscribeJob.perform_later(email)
    self.is_subscribed = 0
  end

  def approved_notification
    return unless status_changed?
    if (status == 'approved')
      AdoptAppMailer.approved_to_adopt_notice(id).deliver_later
    end
  end

  def persisted_comments
    comments.select(&:persisted?)
  end
end
