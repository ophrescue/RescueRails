require 'spec_helper'

describe Event do
  let(:event) { build(:event) }

  context 'has a valid factory' do
    it 'is valid' do
      expect(build(:event)).to be_valid
    end
  end
end
