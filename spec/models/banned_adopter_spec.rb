require 'spec_helper'

describe AdoptionApp do
  let(:banned_adopter) { build(:banned_adopter) }

  context 'has a valid factory' do
    it 'is valid' do
      expect(build(:banned_adopter)).to be_valid
    end
  end
end
