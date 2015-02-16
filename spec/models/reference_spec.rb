require 'spec_helper'

describe Reference do
  let(:reference) { build(:reference) }

  context 'has a valid factory' do
    it 'is valid' do
      expect(reference).to be_valid
    end
  end
end
