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
# Table name: folders
#
#  id         :integer          not null, primary key
#  name       :text
#  created_at :datetime
#  updated_at :datetime
#  locked     :boolean          default(FALSE)
#

class Folder < ApplicationRecord
  has_many :attachments, -> { order('updated_at DESC') }, as: :attachable

  scope :locked, -> { where(locked: true) }
  scope :unlocked, -> { where(locked: false) }
  scope :accessible_by, ->(user){ user.dl_locked_resources ? all : unlocked }

  accepts_nested_attributes_for :attachments, allow_destroy: true

  validates :name, presence: true

  def persisted_attachments
    attachments.select(&:persisted?)
  end
end
