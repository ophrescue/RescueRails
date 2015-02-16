require 'spec_helper'

describe Shelter do
  let(:shelter) { build(:shelter) }

  context 'has a valid factory' do
    it 'is valid' do
      expect(build(:shelter)).to be_valid
    end
  end
end