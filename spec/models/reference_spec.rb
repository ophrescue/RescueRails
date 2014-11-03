require 'spec_helper'

describe Reference do
  let(:reference) { build(:reference) }

  context 'has a valid factory' do
    it 'is valid' do
      expect(reference.valid?).to be_true
    end
  end
end
