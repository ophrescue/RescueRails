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
end
