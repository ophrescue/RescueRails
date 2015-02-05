require 'spec_helper'

describe Adoption do
  let(:adoption) { build(:adoption) }

  before :each do
    Adopter.any_instance.stub(:chimp_check).and_return(true)
    Adopter.any_instance.stub(:chimp_subscribe).and_return(true)
  end

  context 'has a valid factory' do
    it 'saves' do
      expect(build(:adoption)).to be_valid
    end
  end
end
