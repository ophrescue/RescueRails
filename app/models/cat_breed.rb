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

# == Schema Information
#
# Table name: breeds
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class CatBreed < ApplicationRecord
  has_many :primary_breed_cats, class_name: 'Cat', foreign_key: 'primary_breed_id'
  has_many :secondary_breed_cats, class_name: 'Cat', foreign_key: 'secondary_breed_id'

  def display_name
    name
  end
end
