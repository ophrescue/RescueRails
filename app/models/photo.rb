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
# Table name: photos
#
#  id                 :integer          not null, primary key
#  dog_id             :integer
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  created_at         :datetime
#  updated_at         :datetime
#  position           :integer
#  is_private         :boolean          default(FALSE)
#

class Photo < ApplicationRecord
  extend ActionView::Helpers::AssetUrlHelper
  include ClientValidated
  belongs_to :animal, touch: true, polymorphic: true

  HASH_SECRET = "80fd0acd1674d7efdda5b913a7110d5c955e2d73"
  PAPERCLIP_STORAGE_PATH = { test:       "/system/test/photos/:hash.:extension",
                             production: "/dog_photo/:hash.:extension",
                             staging:    "/dog_photo/:hash.:extension" }

  has_attached_file :photo,
            styles: { original: '1280x1024>',
                   large: '640x640',
                   medium: '320x320',
                   thumb: 'x195',
                   minithumb: 'x64#' },
            s3_permissions: "public-read",
            hash_secret: HASH_SECRET

  MIME_TYPES = ['image/jpeg', 'image/png', 'image/pjpeg']

  PHOTO_MAX_SIZE = 10
  validates_attachment_presence :photo
  validates_attachment_size :photo, less_than: PHOTO_MAX_SIZE.megabytes
  validates_attachment_content_type :photo, content_type: MIME_TYPES
  VALIDATION_ERROR_MESSAGES = {photo: ["image_constraints", {max_size: PHOTO_MAX_SIZE}] }

  scope :visible, -> { where(is_private: false) }
  scope :hidden, -> { where(is_private: true) }


  def self.no_photo_url
    ActionController::Base.helpers.asset_path("no_photo.png")
  end

  # galleria dataSource format
  def to_carousel
    {image: photo.url(:original), thumb: photo.url(:medium)}
  end
end
