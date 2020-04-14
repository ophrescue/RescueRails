# == Schema Information
#
# Table name: adoptions
#
#  id            :integer          not null, primary key
#  adopter_id    :integer
#  dog_id        :integer
#  relation_type :string
#  created_at    :datetime
#  updated_at    :datetime
#

require 'rails_helper'

describe Adoption do
  let(:adoption) { build(:adoption) }

  before :each do
    allow(Adopter).to receive(:chimp_check).and_return(true)
    allow(Adopter).to receive(:chimp_subscribe).and_return(true)
  end

  context 'has a valid factory' do
    it 'saves' do
      expect(build(:adoption)).to be_valid
    end
  end
end
