require 'spec_helper'

describe Breed do
  let(:breed) { build(:breed) }

  context 'has a valid factory' do
    it 'is valid' do
      expect(create(:breed)).to be_valid
    end
  end
end