class AdoptionApp < ActiveRecord::Base

	belongs_to :adopter, :class_name => 'Adopter'
	
	attr_accessible :adopter_id,
					:spouse_name,
					:other_household_names,
					:ready_to_adopt_dt,
					:house_type,
					:dog_exercise,
					:dog_stay_when_away,
					:dog_vacation,
					:current_pets,
					:why_not_fixed,
					:current_pets_uptodate,
					:current_pets_uptodate_why,
					:landlord_name,
					:landlord_phone,
					:rent_dog_restrictions,
					:surrender_pet_causes,
					:training_explain,
					:surrendered_pets,
					:how_did_you_hear,
					:pets_branch,
					:current_pets_fixed,
					:rent_costs,
					:vet_info,
					:max_hrs_alone,
					:is_ofage

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
#  dog_exercise              :text
#  dog_stay_when_away        :string(100)
#  dog_vacation              :text
#  current_pets              :text
#  why_not_fixed             :text
#  current_pets_uptodate     :boolean
#  current_pets_uptodate_why :text
#  landlord_name             :string(100)
#  landlord_phone            :string(15)
#  rent_dog_restrictions     :text
#  surrender_pet_causes      :text
#  training_explain          :text
#  surrendered_pets          :text
#  created_at                :timestamp(6)
#  updated_at                :timestamp(6)
#  how_did_you_hear          :string(255)
#  pets_branch               :string(255)
#  current_pets_fixed        :boolean
#  rent_costs                :text
#  vet_info                  :text
#  max_hrs_alone             :integer
#  is_ofage                  :boolean
#

