# == Schema Information
#
# Table name: volunteer_references
#
#  id               :bigint           not null, primary key
#  volunteer_app_id :bigint
#  name             :string
#  email            :string
#  phone            :string
#  relationship     :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class VolunteerReference < ApplicationRecord

  belongs_to :volunteer_app

  validates :name, presence: true, length: { maximum: 50 }
  validates :phone, presence: true, length: { in: 10..25 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :relationship, length: { maximum: 255 }
end
