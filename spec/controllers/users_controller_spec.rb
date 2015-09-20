require 'rails_helper'

describe UsersController, type: :controller do

  let!(:admin) {create(:user, :admin)}
  let!(:hacker) {create(:user)}

  describe 'POST create' do
    context 'logged in as an admin' do
      before :each do
        allow(controller).to receive(:current_user) { admin }
      end

      it 'is able to create a user' do
        expect{
          post :create, user: attributes_for(:user)
        }.to change(User, :count).by(1)
      end
    end

    context 'logged in as normal user' do
      before :each do
        allow(controller).to receive(:current_user) { hacker }
      end

      it 'is unable to create a user' do
        expect{
          post :create, user: attributes_for(:user)
        }.to change(User, :count).by(0)
      end

    end

  end

  describe 'PUT update' do
    before :each do
      @test_user = create(:user)
    end

    context 'logged in as admin' do
      before :each do
        allow(controller).to receive(:current_user) { admin }
      end

      it 'locates the requested user' do
        put :update, id: @test_user, user: attributes_for(:user)
        expect(assigns(:user)).to eq(@test_user)
      end

      it 'updates the users permissions' do
        put :update, id: @test_user,
          user: attributes_for(:user, admin: TRUE, edit_dogs: TRUE)
        @test_user.reload
        expect(@test_user.admin).to eq(TRUE)
        expect(@test_user.edit_dogs).to eq(TRUE)
      end

    end

    context 'logged in as normal user' do
      before :each do
        allow(controller).to receive(:current_user) { hacker }
      end

      it 'is unable to modify user permissions' do
        put :update, id: @test_user,
          user: attributes_for(:user, admin: TRUE, edit_dogs: TRUE)
        @test_user.reload
        expect(@test_user.admin).to eq(FALSE)
        expect(@test_user.edit_dogs).to eq(FALSE)
      end

    end

  end

end