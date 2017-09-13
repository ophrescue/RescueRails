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
#  name                :string(255)
#  email               :string(255)
#  phone               :string(255)
#  address1            :string(255)
#  address2            :string(255)
#  city                :string(255)
#  state               :string(255)
#  zip                 :string(255)
#  status              :string(255)
#  when_to_call        :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  dog_reqs            :text
#  why_adopt           :text
#  dog_name            :string(255)
#  other_phone         :string(255)
#  assigned_to_user_id :integer
#  flag                :string(255)
#  is_subscribed       :boolean          default(FALSE)
#  completed_date      :date
#  county              :string
#

class Adopter < ApplicationRecord
  include Auditable

  attr_accessor :pre_q_costs,
                :pre_q_surrender,
                :pre_q_abuse,
                :pre_q_reimbursement,
                :pre_q_limited_info,
                :pre_q_breed_info,
                :pre_q_dog_adjust,
                :pre_q_courtesy,
                :pre_q_travel,
                :pre_q_hold

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

  def attributes_to_audit
    %w(status assigned_to_user_id email phone address1 address2 city state zip)
  end
  has_many :references, dependent: :destroy
  accepts_nested_attributes_for :references

  has_many :adoptions, dependent: :destroy
  accepts_nested_attributes_for :adoptions

  has_one :adoption_app, dependent: :destroy
  accepts_nested_attributes_for :adoption_app

  has_many :dogs, through: :adoptions
  has_many :comments, -> { order('created_at DESC') }, as: :commentable

  belongs_to :user, class_name: 'User', primary_key: 'id', foreign_key: 'assigned_to_user_id'

  validates :name, presence: true, length: { maximum: 50 }
  validates :phone, presence: true, length: { in: 10..25 }
  validates :address1, presence: true
  validates :city, presence: true
  validates :state, presence: true, length: { is: 2 }
  validates :zip, presence: true, length: { in: 5..10 }

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
    %w(status assigned_to_user_id email phone address1 address2 city state zip)
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
    if (status == 'adopted') || (status == 'completed')
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

    if (status == 'completed')
      completed_date = Time.now.strftime('%m/%d/%Y')
    else
      completed_date = ''
    end

    merge_vars = {
      'FNAME' => name,
      'MMERGE2' => status,
      'MMERGE3' => completed_date
    }
    AdopterSubscribeJob.perform_later(email, merge_vars, interests)
    self.is_subscribed = true
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
end
