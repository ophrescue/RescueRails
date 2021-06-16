#    Copyright 2021 Operation Paws for Homes
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

class Badge < ApplicationRecord
  include ClientValidated
  has_and_belongs_to_many :users, optional: true

  PAPERCLIP_STORAGE_PATH = { test:       "/system/test/badges/:hash.:extension",
                             production: "/badges/:hash.:extension",
                             staging:    "/badges/:hash.:extension" }

  CONTENT_TYPES = {"Images"=>['image/jpg', 'image/jpeg', 'image/pjpeg', 'image/png', 'image/x-png', 'image/gif']}

  MIME_TYPES = CONTENT_TYPES.values.flatten

  HASH_SECRET = 'e17ac013aa7f8f2fd095edfa012edb8c'

  has_attached_file :image,
        styles: {
          original: 'x1024',
          thumb: 'x125'
        },
        hash_secret: HASH_SECRET

  IMAGE_MAX_SIZE = 2

  validates_attachment_presence :image
  validates_attachment_size :image, less_than: IMAGE_MAX_SIZE.megabytes
  validates_attachment_content_type :image, content_type: MIME_TYPES
  VALIDATION_ERROR_MESSAGES = {image: ["image_constraints", {max_size: IMAGE_MAX_SIZE}] }

end
