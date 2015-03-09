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
#  created_at         :timestamp(6)
#  updated_at         :timestamp(6)
#  latitude           :float
#  longitude          :float
#  event_date         :date
#  start_time         :time(6)
#  end_time           :time(6)
#  location_url       :string(255)
#  location_phone     :string(255)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :timestamp(6)
#  photographer_name  :string(255)
#  photographer_url   :string(255)
#  facebook_url       :string(255)
#

require 'spec_helper'

describe Event do
  let(:event) { build(:event) }

  context 'has a valid factory' do
    it 'is valid' do
      expect(build(:event)).to be_valid
    end
  end
end
