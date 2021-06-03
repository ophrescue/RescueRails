require 'rails_helper'

describe Badge do
  let(:badge) { build(:badge) }

  context 'has a valid factory' do
    it 'is valid' do
      expect(build(:badge)).to be_valid
    end
  end
end
