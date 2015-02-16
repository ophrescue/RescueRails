require 'spec_helper'

describe AdoptionApp do
  let(:adoption_app) { build(:adoption_app) }

  before :each do
    allow(Adopter).to receive(:chimp_check).and_return(true)
    allow(Adopter).to receive(:chimp_subscribe).and_return(true)
  end

  context 'has a valid factory' do
    it 'saves' do
      expect(create(:adoption_app)).to be_valid
    end
  end
end
