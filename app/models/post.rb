# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  user_id    :bigint
#  type       :string
#  title      :string
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

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

class Post < ActiveRecord::Base
  include ClientValidated
  VALIDATION_ERROR_MESSAGES = {content: :blank}.freeze

  VALID_TAGS = %w[p strong em a ol ul li].freeze
  VALID_ATTRIBUTES = %w[href].freeze

  belongs_to :user

  scope :bulletins, -> { where(type: 'Bulletin') }
  scope :opportunities, -> { where(type: 'Opportunity') }
end
