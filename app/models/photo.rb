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
  belongs_to :dog, touch: true
  acts_as_list scope: :dog

  HASH_SECRET = "80fd0acd1674d7efdda5b913a7110d5c955e2d73"

  has_attached_file :photo,
            styles: { original: '1280x1024>',
                   large: '640x640',
                   medium: '320x320',
                   thumb: 'x195',
                   minithumb: 'x64#' },
            s3_permissions: "public-read",
            path: ":rails_root/public/system/dog_photo/:hash.:extension",
            url: "/system/dog_photo/:hash.:extension",
            hash_secret: HASH_SECRET,
            preserve_files: !Rails.env.production? # in dev and test we only read AWS, never write/delete

  validates_attachment_presence :photo
  validates_attachment_size :photo, less_than: 10.megabytes
  validates_attachment_content_type :photo, content_type: ['image/jpeg', 'image/png', 'image/pjpeg']

  scope :visible, -> { where(is_private: false) }
  scope :hidden, -> { where(is_private: true) }

  def self.no_photo_url
    "/assets/no_photo.svg"
  end

  # galleria dataSource format
  def to_carousel
    {image: photo.url(:original), thumb: photo.url(:medium)}
  end
end
