require 'rails_helper'

describe DogsController, type: :controller do

  let!(:admin) {create(:user, :admin)}

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

  describe 'POST create' do

    context 'logged in as dog adder admin' do

      before :each do
        allow(controller).to receive(:current_user) { admin }
      end

      it 'is able to create a dog' do
        expect{
          post :create, dog: attributes_for(:dog_with_photo_and_attachment)
        }.to change(Dog, :count).by(1)
      end
    end
  end

  describe 'PUT update' do
    let(:test_dog) {create(:dog, name: 'Old Dog Name') }
    let(:request) { -> {put :update, id: test_dog.id, dog: attributes_for(:dog, name: 'New Dog Name')}}

    context 'logged in as admin' do
      before :each do
        allow(controller).to receive(:current_user) {admin}
      end

      it 'updates the dog name' do
        expect { request.call }.to change{ test_dog.reload.name }.from('Old Dog Name').to('New Dog Name')
      end

    end
  end

end
