# == Schema Information
#
# Table name: volunteer_foster_apps
#
#  id                       :bigint           not null, primary key
#  volunteer_app_id         :bigint
#  can_foster_dogs          :boolean
#  can_foster_cats          :boolean
#  home_type                :string
#  rental_restrictions      :text
#  rental_landlord_name     :string
#  rental_landlord_info     :text
#  has_pets                 :boolean
#  vet_info                 :text
#  current_pets             :text
#  current_pets_spay_neuter :text
#  about_family             :text
#  breed_pref               :text
#  ready_to_foster_dt       :date
#  max_time_alone           :integer
#  dog_fenced_in_yard       :boolean
#  dog_exercise             :text
#  kept_during_day          :text
#  kept_at_night            :text
#  kept_when_alone          :text
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  foster_experience        :text
#
class VolunteerFosterApp < ApplicationRecord
  belongs_to :volunteer_app

  validates :home_type, presence: true
  validates :landlord_name, presence: true, length: { maximum: 200 }, if: :rents_home?
  validates :rental_landlord_info, presence: true, if: :rents_home?
  validates :rental_restrictions, presence: true, if: :rents_home?

  validates :has_pets, presence: true
  validates :vet_info, presence: true, if: :has_pets?
  validates :current_pets, presence: true, if: :has_pets?
  validates :current_pets_spay_neuter, presence: true, if: :has_pets?

  validates :about_family, presence: true
  validates :breed_pref, presence: true
  validates :ready_to_foster_dt, presence: true
  validates :max_time_alone, presence: true
  validates :dog_fenced_in_yard, presence: true, if: :can_foster_dogs?
  validates :dog_exercise, presence: true, if: :can_foster_dogs?
  validates :kept_during_day, presence: true
  validates :kept_at_night, presence: true
  validates :kept_when_alone, presence: true
  validates :foster_experience, presence: true

  def rents_home?
    home_type == "rent"
  end

end
