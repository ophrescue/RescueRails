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
#  landlord_email            :string
#  shot_dhpp_dhlpp           :boolean
#  shot_fpv_fhv_fcv          :boolean
#  shot_rabies               :boolean
#  shot_bordetella           :boolean
#  shot_heartworm            :boolean
#  shot_flea_tick            :boolean
#  verify_home_auth          :boolean          default(FALSE)
#  has_family_under_18       :boolean
#

class AdoptionApp < ApplicationRecord
  belongs_to :adopter, class_name: 'Adopter'
  audited associated_with: :adopter

  has_many :attachments, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :attachments, allow_destroy: true

  validates :ready_to_adopt_dt, presence: true
  validates :dog_stay_when_away, presence: true, length: { maximum: 100 }
  validates :landlord_name, allow_blank: true, length: { maximum: 100 }
  validates :spouse_name, allow_blank: true, length: { maximum: 255 }
  validates :other_household_names, allow_blank: true, length: { maximum: 255 }
  validates :how_did_you_hear, allow_blank: true, length: { maximum: 255 }
end
