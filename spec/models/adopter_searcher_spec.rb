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

    context 'by secondary email' do
      let!(:found_adopter) { create(:adopter, name: 'Frank', email: 'frank@test.com', secondary_email: 'joe@test.com') }
      let(:params) { { search: 'joe@test.com' } }
      it 'finds the correct adopter' do
        expect(results).to match_array([found_adopter])
      end
    end

    context 'by phone number - just numbers, main number' do
      let!(:found_adopter) { create(:adopter, phone: '(213) 456-7890') }
      let(:params) { { search: '2134567890' } }
      it 'finds the correct adopter' do
        expect(results).to match_array([found_adopter])
      end
    end

    context 'by phone number - numbers and dashes, main number' do
      let!(:found_adopter) { create(:adopter, phone: '(213) 456-7890') }
      let(:params) { { search: '213-456-7890' } }
      it 'finds the correct adopter' do
        expect(results).to match_array([found_adopter])
      end
    end

    context 'by phone number - parens and dash, main number' do
      let!(:found_adopter) { create(:adopter, phone: '(213) 456-7890') }
      let(:params) { { search: '(213) 456-7890' } }
      it 'finds the correct adopter' do
        expect(results).to match_array([found_adopter])
      end
    end

    context 'by phone number - parens and dash, other number' do
      let!(:found_adopter) { create(:adopter, other_phone: '(213) 456-7890') }
      let(:params) { { search: '(213) 456-7890' } }
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

  describe 'display filtered adopters' do
    let(:adopters_to_display) { AdopterSearcher.search(params: params, user_id: 1) }
    let(:assigned_to_me) { create(:adopter, :with_app, status: 'approved', assigned_to_user_id: 1) }
    let(:assigned_to_other) { create(:adopter, :with_app, status: 'approved', assigned_to_user_id: 2) }
    let(:unassigned_to) { create(:adopter, :with_app, status: 'approved', assigned_to_user_id: nil) }

    context 'my apps' do    
      let(:params){{show: "MyApplications"}}
      it 'filters by id when my apps is selected' do
        expect(adopters_to_display).to include(assigned_to_me)
        expect(adopters_to_display).to_not include(assigned_to_other)
        expect(adopters_to_display).to_not include(assigned_to_other)
      end
    end

    context 'open apps' do
      let(:params){{show: "OpenApplications"}}
      it 'filters unassigned apps when open apps is selected' do
        expect(adopters_to_display).to include(unassigned_to)
        expect(adopters_to_display).to_not include(assigned_to_me)
        expect(adopters_to_display).to_not include(assigned_to_other)
      end
    end

    context 'all apps' do
      let(:params){{show: "AllApplications"}}
      it 'show all active apps when all apps is selected' do
        expect(adopters_to_display).to include(assigned_to_other)
        expect(adopters_to_display).to_not include(unassigned_to)
        expect(adopters_to_display).to_not include(assigned_to_me)
      end
    end

  end

end
