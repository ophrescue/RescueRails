#    Copyright 2018 Operation Paws for Homes
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

class Campaign < ApplicationRecord
  attr_accessor :photo_delete, :source

  before_save :delete_photo!

  ATTACHMENT_MAX_SIZE = 5
  VALIDATION_ERROR_MESSAGES = {photo: ["attachment_constraints", {max_size: ATTACHMENT_MAX_SIZE}]}

  validates_presence_of :title,
                        :goal,
                        :description

  has_many :donations, dependent: :restrict_with_error

  has_attached_file :photo,
                    styles: { medium: '800x800>',
                              small: '400x400',
                              thumb: '200x200>' },
                    path: ':rails_root/public/system/campaign_photo/:id/:style/:filename',
                    url: '/system/campaign_photo/:id/:style/:filename'

  validates_attachment_size :photo, less_than: ATTACHMENT_MAX_SIZE.megabytes
  validates_attachment_content_type :photo, content_type: ['image/jpeg', 'image/png', 'image/pjpeg']

  def self.client_validation_error_messages_for(field, params)
    key = VALIDATION_ERROR_MESSAGES[field] || :blank
    if key.is_a?(Array)
      key, params = key
      I18n.t("errors.messages.#{key}", params)
    else
      I18n.t("errors.messages.#{key}")
    end
  end

  def progress
    donations.sum(:amount)
  end

  private

  def delete_photo!
    photo.clear if photo_delete == '1'
  end
end
