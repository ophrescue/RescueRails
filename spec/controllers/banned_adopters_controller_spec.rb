require 'rails_helper'

describe BannedAdoptersController, type: :controller do

  let!(:admin) {create(:user, :admin)}
  let!(:hacker) {create(:user)}

  describe 'POST create' do
    context 'logged in as an admin' do
      before :each do
        allow(controller).to receive(:current_user) { admin }
      end

      it 'is able to create a banned adopter' do
        expect{
          post :create, banned_adopter: attributes_for(:banned_adopter)
        }.to change(BannedAdopter, :count).by(1)
      end
    end

    context 'logged in as normal user' do
      before :each do
        allow(controller).to receive(:current_user) { hacker }
      end

      it 'is unable to create a banned adopter' do
        expect{
          post :create, banned_adopter: attributes_for(:banned_adopter)
        }.to change(BannedAdopter, :count).by(0)
      end

    end

  end

  describe 'PUT update' do
    let(:test_banned_adopter) { create(:banned_adopter, name: 'Joe Smith') }
    let(:request) { -> {put :update, id: test_banned_adopter.id, banned_adopter: attributes_for(:banned_adopter, name: 'Tom Jones')} }

    context 'logged in as admin' do
      before :each do
        allow(controller).to receive(:current_user) { admin }
      end

      it 'updates the banned adopter name' do
        expect { request.call }.to change{ test_banned_adopter.reload.name }.from('Joe Smith').to('Tom Jones')
      end

    end

    context 'logged in as normal user' do
      before :each do
        allow(controller).to receive(:current_user) { hacker }
      end

      it 'is unable to modify user permissions' do
        expect { request.call }.to_not change{ test_banned_adopter.reload.name }
      end

    end

  end

end