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
#  writing_interest       :boolean
#  events_interest        :boolean
#  fostering_interest     :boolean
#  training_interest      :boolean
#  fundraising_interest   :boolean
#  transport_bb_interest  :boolean
#  adoption_team_interest :boolean
#  admin_interest         :boolean
#  about                  :text
#
class VolunteerApp < ApplicationRecord

  has_many :volunteer_references, dependent: :destroy
  accepts_nested_attributes_for :volunteer_references

  has_one :volunteer_foster_app, dependent: :destroy
  accepts_nested_attributes_for :volunteer_foster_app

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
end
