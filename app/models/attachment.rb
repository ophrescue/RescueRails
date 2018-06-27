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
  belongs_to :attachable, polymorphic: true
  belongs_to :updated_by_user, class_name: 'User'

  has_attached_file :attachment,
            path: ":rails_root/public/system/#{Rails.env}/attachment/:hash.:extension",
            url: '/system/attachments/:hash.:extension',
            hash_secret: 'e17ac013aa7f8f2fd095edfa012edb8c',
            s3_permissions: :private

  validates_attachment_presence :attachment
  validates_attachment_size :attachment, less_than: 100.megabytes
  validates_attachment_content_type :attachment,
   content_type: ['image/jpg', 'image/jpeg', 'image/pjpeg', 'image/png', 'image/x-png', 'image/gif', 'application/pdf',
            'application/msword', 'applicationvnd.ms-word', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
            'application/msexcel', 'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
            'application/mspowerpoint', 'application/vnd.ms-powerpoint', 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
            'text/plain'],
   message: 'Images, Docs, PDF, Excel and Plain Text Only.'

  AGREEMENT_TYPE_FOSTER = 'foster'
  AGREEMENT_TYPE_CONFIDENTIALITY = 'confidentiality'
  AGREEMENT_TYPE_CODE_OF_CONDUCT = 'code of conduct'

  def download_url(style_name = :original)
    attachment.expiring_url(3600, style_name)
  end
end
