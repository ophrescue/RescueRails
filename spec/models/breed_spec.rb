require 'spec_helper'

describe Breed do
  let(:breed) { build(:breed) }

  context 'has a valid factory' do
    it 'is valid' do
      expect(breed.valid?).to be_true
    end
  end
end
