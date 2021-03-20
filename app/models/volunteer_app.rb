# == Schema Information
#
# Table name: volunteer_apps
#
#  id                     :bigint           not null, primary key
#  name                   :string
#  email                  :string
#  phone                  :string
#  address1               :string
#  address2               :string
#  city                   :string
#  region                 :string(2)
#  postal_code            :string
#  referrer               :string
#  events_interest        :boolean
#  fostering_interest     :boolean
#  training_interest      :boolean
#  fundraising_interest   :boolean
#  transport_bb_interest  :boolean
#  adoption_team_interest :boolean
#  admin_interest         :boolean
#  about                  :text
#  status                 :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  marketing_interest     :boolean
#
class VolunteerApp < ApplicationRecord
  audited on: :update
  has_associated_audits
  include ClientValidated

  VALIDATION_ERROR_MESSAGES = { name: :blank }

  has_many :volunteer_references, dependent: :destroy
  accepts_nested_attributes_for :volunteer_references

  has_one :volunteer_foster_app, dependent: :destroy
  accepts_nested_attributes_for :volunteer_foster_app

  has_many :comments, -> { order('created_at DESC') }, as: :commentable

  validates :name, presence: true, length: { maximum: 50 }
  validates :phone, presence: true, length: { in: 10..25 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :address1, presence: true, length: { maximum: 255 }
  validates :address2, allow_blank: true, length: { maximum: 255 }
  validates :city, presence: true, length: { maximum: 255 }
  validates :region, presence: true, length: { is: 2 }
  validates :postal_code, presence: true, length: { in: 5..10 }
  validates :referrer, allow_blank: true, length: { maximum: 255 }
  validates :about, presence: true, length: { maximum: 30000 }

  STATUSES = ['new',
              'workup',
              'ready for call',
              'on hold',
              'approved',
              'withdrawn']

  INTERESTS = ['marketing',
               'events',
               'fostering',
               'training',
               'fundraising',
               'transport',
               'adoption',
               'admin']

  scope :filter_by_status, -> (status) { where status: status }

  def comments_and_audits_and_associated_audits
    (persisted_comments + audits + associated_audits).sort_by(&:created_at).reverse!
  end

  def persisted_comments
    comments.select(&:persisted?)
  end

  def audits_and_associated_audits
    (audits + associated_audits).sort_by(&:created_at).reverse!
  end

  def self.filter_by_interest(interest)
    if interest == 'marketing'
      where(marketing_interest: true)
    elsif interest == 'events'
      where(events_interest: true)
    elsif interest == 'fostering'
      where(fostering_interest: true)
    elsif interest == 'training'
      where(training_interest: true)
    elsif interest == 'fundraising'
      where(fundraising_interest: true)
    elsif interest == 'transport'
      where(transport_bb_interest: true)
    elsif interest == 'adoption'
      where(adoption_team_interest: true)
    elsif interest == 'admin'
      where(admin_interest: true)
    else
      all
    end
  end
end
