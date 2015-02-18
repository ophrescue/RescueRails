require 'spec_helper'

describe DogsController, type: :controller do

  shared_examples 'an OK response with 1 dog' do
    it 'responds successfully' do
      expect(response).to be_success
    end

    it 'contains 1 dog' do
      last_json = JSON.parse(response.body)
      expect(last_json.length).to eq(1)
    end

    it 'contains found dog' do
      expect([found_dog].to_json).to be_json_eql(response.body)
    end
  end

  describe 'GET #index' do
    context 'user is logged in' do
      let!(:found_dog) { create(:dog, tracking_id: 1) }
      let!(:other_dog) { create(:dog, tracking_id: 100) }
      let(:params) { {} }

      subject(:get_index) { get :index, params.merge(format: :json), {mgr_view: true} }

      before do
        allow(controller).to receive(:signed_in?).and_return(true)
      end

      context 'search by tracking id' do
        let(:params) { { search: 1 } }

        before do
          get_index
        end

        it_behaves_like 'an OK response with 1 dog'
      end

      context 'search by name' do
        let!(:found_dog) { create(:dog, name: 'oscar') }
        let(:params) { { search: 'oscar' } }

        before do
          get_index
        end

        it_behaves_like 'an OK response with 1 dog'
      end

      context 'search by active status' do
        let!(:found_dog) { create(:dog, :adoptable) }
        let!(:other_dog) { create(:dog, :completed) }
        let(:params) { { status: 'active' } }

        before do
          get_index
        end

        it_behaves_like 'an OK response with 1 dog'
      end

      context 'search by any status' do
        let!(:found_dog) { create(:dog, :completed) }
        let!(:other_dog) { create(:dog, :adoptable) }
        let(:params) { { status: 'completed' } }

        before do
          get_index
        end

        it_behaves_like 'an OK response with 1 dog'
      end

      context 'search by name in q param' do
        let!(:found_dog) { create(:dog, name: 'oscar') }
        let(:params) { { q: 'oscar' } }

        before do
          get_index
        end

        it_behaves_like 'an OK response with 1 dog'
      end

      context 'searching with no params returns no results' do
        let(:params) { {} }

        it 'responds successfully' do
          expect(response).to be_success
        end

        it 'contains 0 dogs' do
          expect(response.body).to be_blank
        end
      end
    end

    context 'user is not logged in' do
      let!(:found_dog) { create(:dog, :adoptable) }
      let!(:other_dog) { create(:dog, :completed) }
      let(:params) { {} }

      subject(:get_index) { get :index, params.merge(format: :json) }

      before do
        allow(controller).to receive(:signed_in?).and_return(false)
        get_index
      end

      it_behaves_like 'an OK response with 1 dog'
    end
  end
end
