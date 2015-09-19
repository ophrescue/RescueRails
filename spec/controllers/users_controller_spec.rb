require 'rails_helper'

describe UsersController, type: :controller do

  describe 'User creation' do
    let!(:admin) {create(:user, :admin)}
    let!(:hacker) {create(:user)}

    context 'logged in as an admin' do
      before :each do
        allow(controller).to receive(:current_user) { admin }
      end

      it 'is able to create a user' do
        expect{
          post :create, user: attributes_for(:user)
        }.to change(User, :count).by(1)
      end

      it 'can modify the users permissions' do
        #post :create, build(:user, edit_dogs: FALSE)
        #verify the edit_dogs is false in the database
        #put udate edit_dogs to true for this record
        #verify edit_dogs is true for this record
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

      it 'is unable to modify their own permissions' do
        #post :create, build(:user, edit_dogs: FALSE)
        #verify the edit_dogs is false in the database
        #put udate edit_dogs to true for this record
        #verify edit_dogs is STILL FALSE/generate error for this record
      end

    end

  end
end