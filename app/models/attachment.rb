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
# Table name: attachments
#
#  id                      :integer          not null, primary key
#  attachable_id           :integer
#  attachable_type         :string(255)
#  attachment_file_name    :string(255)
#  attachment_content_type :string(255)
#  attachment_file_size    :integer
#  attachment_updated_at   :datetime
#  updated_by_user_id      :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  description             :text
#  agreement_type          :string
#
class Attachment < ApplicationRecord
  include ClientValidated

  belongs_to :attachable, polymorphic: true

  belongs_to :updated_by_user, class_name: 'User'

  scope :matching, ->(search_term){ where('attachment_file_name ILIKE :search OR attachments.description ILIKE :search', search: "%#{search_term&.strip}%") }

  PAPERCLIP_STORAGE_PATH = { test:       "/system/test/attachments/:hash.:extension",
                             production: "/attachments/:hash.:extension",
                             staging:    "/attachments/:hash.:extension" }

  CONTENT_TYPES = {"Images"=>['image/jpg', 'image/jpeg', 'image/pjpeg', 'image/png', 'image/x-png', 'image/gif'],
                   "Docs"=>['application/msword', 'application/vnd.ms-word',
                   'application/msexcel', 'application/vnd.ms-excel',
                   'application/mspowerpoint', 'application/vnd.ms-powerpoint',
                   'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
                   'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                   'application/vnd.openxmlformats-officedocument.presentationml.presentation'],
                   "PDF"=>'application/pdf', "Plain Text"=>'text/plain'}

  MIME_TYPES = CONTENT_TYPES.values.flatten

  HASH_SECRET = 'e17ac013aa7f8f2fd095edfa012edb8c'

  has_attached_file :attachment,
            hash_secret: HASH_SECRET,
            s3_permissions: :private

  ATTACHMENT_MAX_SIZE = 100

  validates_attachment_presence :attachment
  validates_attachment_size :attachment, less_than: ATTACHMENT_MAX_SIZE.megabytes
  do_not_validate_attachment_file_type :attachment

  VALIDATION_ERROR_MESSAGES = {attachment: ["attachment_constraints", {max_size: ATTACHMENT_MAX_SIZE}] }

  AGREEMENT_TYPE_FOSTER = 'foster'
  AGREEMENT_TYPE_CONFIDENTIALITY = 'confidentiality'
  AGREEMENT_TYPE_CODE_OF_CONDUCT = 'code of conduct'

  def download_url(style_name = :original)
    attachment.expiring_url(3600, style_name)
  end
end
