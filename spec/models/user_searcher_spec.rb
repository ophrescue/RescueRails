require 'rails_helper'

describe UserSearcher do
  describe '.search' do
    let(:results) { UserSearcher.search(params: params) }

    context 'search by name' do
      let!(:found_user) { create(:user, name: 'Ann') }
      let(:params) { { search: 'Ann' } }

      it 'finds the correct user by name' do
        expect(results).to match_array([found_user])
      end
    end

    context 'search by email' do
      let!(:found_user) { create(:user, name: 'Ann', email: 'ann@test.com') }
      let(:params) { { search: 'ann@test.com' } }

      it 'finds the correct user by email' do
        expect(results).to match_array([found_user])
      end
    end

    context 'search by location' do
      let!(:found_user) { create(:user, name: 'Ann', city: 'Brooklyn') }
      let(:params) { { location: 'Brooklyn' } }

      it 'finds the correct user by location' do
        expect(results).to match_array([found_user])
      end
    end
  end
end
