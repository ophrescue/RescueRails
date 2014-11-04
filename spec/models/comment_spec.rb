require 'spec_helper'

describe Comment do
  let(:comment) { build(:comment) }

  context 'has a valid factory' do
    it 'is valid' do
      expect(comment.valid?).to be_true
    end
  end
end
