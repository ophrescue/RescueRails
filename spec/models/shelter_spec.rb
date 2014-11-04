require 'spec_helper'

describe Shelter do
  let(:shelter) { build(:shelter) }

  context 'has a valid factory' do
    it 'is valid' do
      expect(shelter.valid?).to be_true
    end
  end
end
