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

require 'rails_helper'

describe Event do
  it 'has a valid factory' do
    expect(build(:event)).to be_valid
  end

  it 'is valid when location_url is blank' do
    expect(build(:event, location_url: nil)).to be_valid
  end
end
