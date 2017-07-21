require 'rails_helper'

describe UserSearcher do
  describe '.search' do
    let(:results) { UserSearcher.search(params: params) }

    context 'search by name' do
      let!(:found_user) { create(:user, name: 'Ann') }
      let!(:other_user) { create(:user, name: 'Bob') }
      let(:params) { { search: 'Ann' } }

      it 'finds the correct user by name' do
        expect(results).to include(found_user)
        expect(results).to_not include(other_user)
      end
    end

    context 'search by email' do
      let!(:found_user) { create(:user, email: 'ann@test.com') }
      let!(:other_user) { create(:user, email: 'bob@test.com') }
      let(:params) { { search: 'ann@test.com' } }

      it 'finds the correct user by email' do
        expect(results).to include(found_user)
        expect(results).to_not include(other_user)
      end
    end

    context 'search by location' do
      let!(:found_user) { create(:user, name: 'Ann', city: 'Brooklyn') }
      let(:params) { { location: 'Brooklyn' } }

      it 'finds the correct user by location' do
        expect(results).to include(found_user)
      end
    end
  end
end
