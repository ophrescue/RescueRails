
require 'rails_helper'

describe Bulletin do
  let(:bulletin) { build(:bulletin) }

  context 'has a valid factory' do
      it 'is valid' do
      expect(build(:bulletin)).to be_valid
      end
  end
end
