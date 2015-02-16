require 'spec_helper'

describe Comment do
  let(:comment) { build(:comment) }

  context 'has a valid factory' do
    it 'is valid' do
      expect(build(:comment)).to be_valid
    end
  end
end
