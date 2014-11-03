require 'spec_helper'

describe AdoptionApp do
  let(:banned_adopter) { build(:banned_adopter) }

  context 'has a valid factory' do
    it 'saves' do
      expect(banned_adopter.valid?).to be_true
    end
  end
end
