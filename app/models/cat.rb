#    Copyright 2019 Operation Paws for Homes
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
#
# == Schema Information
#
# Table name: cats
#
#  id                      :bigint           not null, primary key
#  name                    :string
#  original_name           :string
#  tracking_id             :integer
#  primary_breed_id        :integer
#  secondary_breed_id      :integer
#  status                  :string
#  age                     :string(75)
#  size                    :string(75)
#  is_altered              :boolean
#  gender                  :string(6)
#  declawed                :boolean
#  litter_box_trained      :boolean
#  coat_length             :string
#  is_special_needs        :boolean
#  no_dogs                 :boolean
#  no_cats                 :boolean
#  no_kids                 :boolean
#  description             :text
#  foster_id               :integer
#  adoption_date           :date
#  is_uptodateonshots      :boolean          default(TRUE)
#  intake_dt               :date
#  available_on_dt         :date
#  has_medical_need        :boolean          default(FALSE)
#  is_high_priority        :boolean          default(FALSE)
#  needs_photos            :boolean          default(FALSE)
#  has_behavior_problem    :boolean          default(FALSE)
#  needs_foster            :boolean          default(FALSE)
#  petfinder_ad_url        :string
#  craigslist_ad_url       :string
#  youtube_video_url       :string
#  microchip               :string
#  fee                     :integer
#  coordinator_id          :integer
#  sponsored_by            :string
#  shelter_id              :integer
#  medical_summary         :text
#  behavior_summary        :text
#  medical_review_complete :boolean          default(FALSE)
#  first_shots             :string
#  second_shots            :string
#  third_shots             :string
#  rabies                  :string
#  felv_fiv_test           :string
#  flea_tick_preventative  :string
#  dewormer                :string
#  coccidia_treatment      :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class Cat < ApplicationRecord
end
