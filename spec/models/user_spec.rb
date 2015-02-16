require 'spec_helper'

describe User do
  before do
    allow(User).to receive(:chimp_check).and_return(true)
    allow(User).to receive(:chimp_subscribe).and_return(true)
  end

  describe '#out_of_date?' do

    context 'user has no last_verified date' do
      let(:user) { create(:user, lastverified: nil ) }

      it 'returns true' do
        expect(user.out_of_date?).to eq(true)
      end
    end

    context 'user was last_verified over 30 days ago' do
      let(:user) { create(:user, lastverified: 31.days.ago ) }

      it 'returns true' do
        expect(user.out_of_date?).to eq(true)
      end
    end

    context 'user has last_verified of today' do
      let(:user) { create(:user, lastverified: Time.now ) }

      it 'returns false' do
        expect(user.out_of_date?).to eq(false)
      end
    end
  end
end
