require 'spec_helper'

describe Event do
  let(:event) { build(:event) }

  context 'has a valid factory' do
    it 'is valid' do
      expect(event.valid?).to be_true
    end
  end
end
