require 'spec_helper'

describe Adoption do
  let(:adoption) { build(:adoption) }

  context 'has a valid factory' do
    it 'saves' do
      expect(adoption.valid?).to be_true
    end
  end
end
