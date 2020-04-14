# == Schema Information
#
# Table name: shelters
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

describe Shelter do
  let(:shelter) { build(:shelter) }

  context 'has a valid factory' do
    it 'is valid' do
      expect(build(:shelter)).to be_valid
    end
  end
end
