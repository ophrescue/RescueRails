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
# Table name: cat_adoptions
#
#  id            :bigint           not null, primary key
#  adopter_id    :integer
#  cat_id        :integer
#  relation_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class CatAdoption < ApplicationRecord
  belongs_to :cat
  belongs_to :adopter

  has_many :invoices, as: :invoiceable

  RELATION_TYPE = ['interested', 'adopted', 'returned',
        'pending adoption', 'pending return', 'trial adoption']

  validates_inclusion_of :relation_type, in: RELATION_TYPE

  def animal
    return cat
  end
end
