require 'rails_helper'

describe Waitlist do
  let(:waitlist) { build(:waitlist) }

  context 'has a valid factory' do
    it 'is valid' do
      expect(build(:waitlist)).to be_valid
    end
  end
end
