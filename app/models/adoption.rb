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
# Table name: adoptions
#
#  id            :integer          not null, primary key
#  adopter_id    :integer
#  dog_id        :integer
#  relation_type :string
#  created_at    :datetime
#  updated_at    :datetime
#

class Adoption < ApplicationRecord
  belongs_to :dog
  belongs_to :adopter
  has_many :invoices, as: :invoiceable, dependent: :restrict_with_error
  before_update :training_followup_email


  AMOUNT_TO_SHOW = ['MyApplications', 'OpenApplications', 'AllApplications']
  RELATION_TYPE = ['interested', 'adopted', 'returned',
        'pending adoption', 'pending return', 'trial adoption', 'canceled']

  validates_inclusion_of :relation_type, in: RELATION_TYPE

  def animal
    return dog
  end

  def training_followup_email
    return unless relation_type_changed?
    if relation_type == 'adopted'
      TrainingMailer.free_training_notice(adopter.id).deliver_later
      AdopterFollowupMailer.one_week_followup(adopter.id).deliver_later(wait: 7.days)
    end
  end
end
