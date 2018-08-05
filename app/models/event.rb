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
#  title              :string(255)
#  location_name      :string(255)
#  address            :string(255)
#  description        :text
#  created_by_user    :integer
#  created_at         :datetime
#  updated_at         :datetime
#  latitude           :float
#  longitude          :float
#  event_date         :date
#  start_time         :time
#  end_time           :time
#  location_url       :string(255)
#  location_phone     :string(255)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  photographer_name  :string(255)
#  photographer_url   :string(255)
#  facebook_url       :string(255)
#

class Event < ApplicationRecord
  attr_accessor :photo_delete

  ATTACHMENT_MAX_SIZE = 5
  VALIDATION_ERROR_MESSAGES = {location_url: :url_format, facebook_url: :url_format, photo: ["attachment_size", {max_size: ATTACHMENT_MAX_SIZE}]}

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

  scope :upcoming, ->{ where("event_date >= ?", Date.today).limit(30).order('event_date ASC')  }
  scope :past,     ->{ where("event_date < ?",  Date.today).limit(30).order('event_date DESC') }

  def upcoming?
    event_date >= Date.today
  end

  def set_user
    self.created_by_user = @current_user
  end

  def google_map
    GoogleMap.new(self)
  end

  private
  def remove_facebook_url_query_string
    self.facebook_url = self.facebook_url&.split('?')[0]
  end

  def delete_photo!
    photo.clear if photo_delete == '1'
  end
end
