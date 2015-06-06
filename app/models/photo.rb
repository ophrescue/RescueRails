# == Schema Information
#
# Table name: photos
#
#  id                 :integer          not null, primary key
#  dog_id             :integer
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :timestamp(6)
#  created_at         :timestamp(6)
#  updated_at         :timestamp(6)
#  position           :integer
#  is_private         :boolean          default(FALSE)
#

class Photo < ActiveRecord::Base
  belongs_to :dog
  acts_as_list scope: :dog

  attr_accessible :photo,
                  :position,
                  :is_private

  has_attached_file :photo,
            :styles => { :original => '1280x1024>',
                   :large => '640x640',
                   :medium => '320x320',
                   :thumb => 'x195',
                   :minithumb => 'x64#' },
            :s3_permissions => :public_read,
            :path => ":rails_root/public/system/dog_photo/:hash.:extension",
            :url  => "/system/dog_photo/:hash.:extension",
            :hash_secret => "80fd0acd1674d7efdda5b913a7110d5c955e2d73"


  validates_attachment_presence :photo
  validates_attachment_size :photo, less_than: 10.megabytes
  validates_attachment_content_type :photo, content_type: ['image/jpeg', 'image/png', 'image/pjpeg']

  scope :public, -> { where(is_private: false) }
  scope :private, -> { where(is_private: true) }
end
