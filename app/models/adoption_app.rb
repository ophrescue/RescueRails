# == Schema Information
#
# Table name: adoption_apps
#
#  id                        :integer          not null, primary key
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
#  created_at                :datetime
#  updated_at                :datetime
#  how_did_you_hear          :string(255)
#  pets_branch               :string(255)
#  current_pets_fixed        :boolean
#  rent_costs                :text
#  vet_info                  :text
#  max_hrs_alone             :integer
#  is_ofage                  :boolean
#

class AdoptionApp < ActiveRecord::Base
  belongs_to :adopter, class_name: 'Adopter'

  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments, allow_destroy: true
end
