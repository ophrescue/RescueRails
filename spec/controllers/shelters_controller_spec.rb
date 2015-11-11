require 'rails_helper'

describe SheltersController, type: :controller do

  let!(:admin) {create(:user, :admin)}
  let!(:hacker) {create(:user)}

  describe 'POST create' do
    context 'logged in as an admin' do
      before :each do
        allow(controller).to receive(:current_user) { admin }
      end

      it 'is able to create a shelter' do
        expect{
          post :create, shelter: attributes_for(:shelter)
        }.to change(Shelter, :count).by(1)
      end
    end

    context 'logged in as normal shelter' do
      before :each do
        allow(controller).to receive(:current_user) { hacker }
      end

      it 'is unable to create a shelter' do
        expect{
          post :create, shelter: attributes_for(:shelter)
        }.to change(Shelter, :count).by(0)
      end

    end

  end

  describe 'PUT update' do
    let(:test_shelter) { create(:shelter, name: 'BARCS') }
    let(:request) { -> {put :update, id: test_shelter.id, shelter: attributes_for(:shelter, name: 'New Shelter')} }

    context 'logged in as admin' do
      before :each do
        allow(controller).to receive(:current_user) { admin }
      end

      it 'updates the shelter name' do
        expect { request.call }.to change{ test_shelter.reload.name }.from('BARCS').to('New Shelter')
      end

    end

    context 'logged in as normal user' do
      before :each do
        allow(controller).to receive(:current_user) { hacker }
      end

      it 'is unable to modify shelter' do
        expect { request.call }.to_not change{ test_shelter.reload.name }
      end

    end

  end

end