class AdoptionApp < ActiveRecord::Base

	belongs_to :adopter, :class_name => 'Adopter'

	attr_accessor :pets_branch
	
end
# == Schema Information
#
# Table name: adoption_apps
#
#  id                        :integer         not null, primary key
#  adopter_id                :integer
#  spouse_name               :string(50)
#  other_household_names     :string(255)
#  ready_to_adopt_dt         :date
#  house_type                :string(40)
#  has_yard                  :boolean
#  has_fence                 :boolean
#  has_parks                 :boolean
#  dog_exercise              :text
#  dog_stay_when_away        :string(100)
#  max_hrs_alone             :integer         default(8)
#  dog_at_night              :string(100)
#  dog_vacation              :text
#  have_pets                 :boolean
#  had_pets                  :boolean
#  current_pets              :text
#  current_pets_fixed        :string(50)
#  why_not_fixed             :text
#  prior_pets                :text
#  current_pets_uptodate     :boolean
#  current_pets_uptodate_why :text
#  vet_name                  :string(100)
#  vet_phone                 :string(15)
#  landlord_name             :string(100)
#  landlord_phone            :string(15)
#  rent_dog_restrictions     :text
#  rent_deposit              :integer         default(0)
#  rent_increase             :integer         default(0)
#  annual_cost_est           :integer         default(0)
#  plan_training             :text
#  has_new_dog_exp           :boolean
#  surrender_pet_causes      :text
#  training_explain          :text
#  surrendered_pets          :text
#  why_adopt                 :text
#  created_at                :datetime
#  updated_at                :datetime
#  how_did_you_hear          :string(255)
#

