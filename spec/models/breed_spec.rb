# == Schema Information
#
# Table name: breeds
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :timestamp(6)
#  updated_at :timestamp(6)
#

require 'rails_helper'

describe Breed do
  let(:breed) { build(:breed) }

  context 'has a valid factory' do
    it 'is valid' do
      expect(create(:breed)).to be_valid
    end
  end
end
