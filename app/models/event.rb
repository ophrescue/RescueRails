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
# Table name: events
#
#  id                 :integer          not null, primary key
#  title              :string
#  location_name      :string
#  address            :string
#  description        :text
#  created_by_user    :integer
#  created_at         :datetime
#  updated_at         :datetime
#  latitude           :float
#  longitude          :float
#  event_date         :date
#  start_time         :time
#  end_time           :time
#  location_url       :string
#  location_phone     :string
#  photo_file_name    :string
#  photo_content_type :string
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  photographer_name  :string
#  photographer_url   :string
#  facebook_url       :string
#  featured           :boolean
#

class Event < ApplicationRecord
  include ClientValidated
  attr_accessor :photo_delete, :source

  ATTACHMENT_MAX_SIZE = 5
  CONTENT_TYPES = {"Images" => ['image/jpg', 'image/jpeg', 'image/pjpeg', 'image/png', 'image/x-png', 'image/gif']}
  MIME_TYPES = CONTENT_TYPES.values.flatten
  VALIDATION_ERROR_MESSAGES = {location_url: :url_format, facebook_url: :url_format, photo: ["image_constraints", {max_size: ATTACHMENT_MAX_SIZE}]}

  validates_presence_of :title,
                        :event_date,
                        :start_time,
                        :end_time,
                        :location_name,
                        :address,
                        :description

  validates_format_of :location_url, with: URI::regexp(%w[http https]), message: VALIDATION_ERROR_MESSAGES[:location_url], allow_blank: true

  validates :title, length: { maximum: 255 }
  validates :location_name, length: { maximum: 255 }
  validates :address, length: { maximum: 255 }
  validates :location_url, length: { maximum: 255 }
  validates :facebook_url,
            length: { maximum: 255 },
            allow_blank: true

  before_save :set_user
  before_save :delete_photo!
  before_save :remove_facebook_url_query_string

  geocoded_by :address

  after_validation :geocode,
                   if: lambda { |obj| obj.address_changed? }

  has_attached_file :photo,
                    styles: { original: '1024x1024>',
                              medium: '205x300>',
                              thumb: '64x64>' },
                    path: ':rails_root/public/system/event_photo/:id/:style/:filename',
                    url: '/system/event_photo/:id/:style/:filename'

  validates_attachment_size :photo, less_than: ATTACHMENT_MAX_SIZE.megabytes
  validates_attachment_content_type :photo, content_type: MIME_TYPES

  scope :upcoming, ->{ where("event_date >= ?", Date.today).order('event_date, start_time, created_at ASC') }
  scope :past,     ->{ where("event_date < ?",  Date.today).order('event_date, start_time, created_at DESC') }
  scope :featured, ->{ where(featured: true) }

  def upcoming?
    event_date >= Date.today
  end

  def set_user
    self.created_by_user = @current_user
  end

  def google_map
    GoogleMap.new(self)
  end

  # pre-populate the new Event with another event's attributes
  def self.from_template(id)
    attrs_to_omit = ["id", "event_date", "created_at", "updated_at", "start_time", "end_time"]
    attrs = find(id).attributes.except(*attrs_to_omit)
    attrs.merge!({source: id})
    clone = new(attrs)
    photo_url = clone.photo.options[:url]
    # link to the original event's photo image for now, attach it properly when we save
    clone.photo.options[:url] = photo_url.gsub(/:id/,id.to_s )
    clone
  end

  def attach_photo_from(id, request)
    source_event = Event.find(id)
    return unless source_event.photo
    source_photo_url = source_event.photo.url
    source_photo_url.prepend(request.base_url) if source_photo_url =~ /^\// # make the url absolute, there should be a better way!
    self.photo = URI.open(source_photo_url)
    self.photo_file_name, self.photo_content_type, self.photo_file_size, self.photo_updated_at =
      source_event.attributes.values_at "photo_file_name", "photo_content_type", "photo_file_size", "photo_updated_at"
  end

  private
  def remove_facebook_url_query_string
    self.facebook_url = self.facebook_url&.split('?')[0]
  end

  def delete_photo!
    photo.clear if photo_delete == '1'
  end
end
