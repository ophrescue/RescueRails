require 'rails_helper'

describe AdopterSearcher do
  describe '.search' do
    let(:results) { AdopterSearcher.search(params: params) }

    context 'by name' do
      let!(:found_adopter) { create(:adopter, name: 'Frank') }
      let!(:other_adopter) { create(:adopter, name: 'Tom') }
      let(:params) { { search: 'frank' } }

      it 'finds the correct adopter' do
        expect(results).to include(found_adopter)
        expect(results).to_not include(other_adopter)
      end
    end

    context 'by email' do
      let!(:found_adopter) { create(:adopter, name: 'Frank', email: 'frank@test.com') }
      let(:params) { { search: 'frank' } }
      it 'finds the correct adopter' do
        expect(results).to match_array([found_adopter])
      end
    end

    context 'by active status' do
      let!(:found_adopter) { create(:adopter, status: 'new') }
      let!(:other_adopter) { create(:adopter, status: 'denied') }
      let(:params) { { status: 'active' } }

      it 'finds the correct adopter' do
        expect(results).to include(found_adopter)
        expect(results).to_not include(other_adopter)
      end
    end

    context 'by status' do
      let!(:found_adopter) { create(:adopter, status: 'denied') }
      let!(:other_adopter) { create(:adopter, status: 'new') }
      let(:params) { { status: 'denied' } }

      it 'finds the correct adopter' do
        expect(results).to include(found_adopter)
        expect(results).to_not include(other_adopter)
      end
    end

    context 'all adopters' do
      let!(:found_adopter) { create(:adopter, status: 'denied') }
      let!(:other_adopter) { create(:adopter, status: 'new') }
      let(:params) { {} }

      it 'finds the correct adopter' do
        expect(results).to include(found_adopter)
        expect(results).to include(other_adopter)
      end
    end
  end
end
