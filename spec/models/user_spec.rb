require 'spec_helper'

describe User do
  before do
    allow(User).to receive(:chimp_check).and_return(true)
    allow(User).to receive(:chimp_subscribe).and_return(true)
  end


  describe 'contact information' do

    context 'with valid fields' do
      it 'should accept a two letter state' do
        user = build(:user, state: 'PA')
        expect(user).to be_valid
      end
      it 'should accet a 5 digit zipcode' do
        user = build(:user, zip: '12345')
        expect(user).to be_valid
      end
      it 'should save a state abbreviation in all caps' do
        user = create(:user, state: 'pa')
        expect(user.state).to eq('PA')
      end
    end

    context 'with invalid fields' do
      it 'is invalid with a state more than 2 letters' do
        user = build(:user, state: 'Penn')
        user.valid?
        expect(user.errors[:state]).to include('is the wrong length (should be 2 characters)')
      end
      it 'is invalid with a zip code of more than 5 characters' do
        user = build(:user, zip: 'virgina')
        user.valid?
        expect(user.errors[:zip]).to include('should be 12345 or 12345-1234')
      end
    end
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
