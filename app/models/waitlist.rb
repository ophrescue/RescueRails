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
# Table name: waitlists
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  description         :string(255)

class Waitlist < ApplicationRecord
  has_many :dogs, -> { order 'rank ASC'}
  accepts_nested_attributes_for :dogs

  has_many :adopter_waitlists, -> { order 'rank ASC' }, dependent: :destroy
  accepts_nested_attributes_for :adopter_waitlists

  has_many :adopters, through: :adopter_waitlists
end
