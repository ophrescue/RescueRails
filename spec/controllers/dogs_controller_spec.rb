require 'spec_helper'

describe DogsController, type: :controller do
  describe 'GET #index' do

    context 'user is logged in' do
      let!(:dog) { create(:dog) }
      let(:params) { {} }

      subject(:get_index) { get :index, params.merge(format: :json), {mgr_view: true} }

      before do
        allow(DogSearcher).to receive(:search).and_return([dog])
        allow(controller).to receive(:signed_in?).and_return(true)
      end

      it 'returns dog as json' do
        get_index

        expect([dog].to_json).to be_json_eql(response.body)
      end
    end

  end
end
