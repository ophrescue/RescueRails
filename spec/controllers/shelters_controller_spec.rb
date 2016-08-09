# == Schema Information
#
# Table name: shelters
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe SheltersController, type: :controller do
  let!(:hacker) { create(:user) }

  describe 'GET #index' do
    include_context 'signed in admin'

    it 'is successful' do
      get :index
      expect(response).to be_success
    end
  end

  describe 'GET #show' do
    include_context 'signed in admin'

    let(:shelter) { create(:shelter) }

    it 'is successful' do
      get :show, id: shelter.id
      expect(response).to be_success
    end
  end

  describe 'GET #new' do
    include_context 'signed in admin'

    it 'is successful' do
      get :new
      expect(response).to be_success
    end
  end

  describe 'GET #edit' do
    include_context 'signed in admin'

    let(:shelter) { create(:shelter) }

    it 'is successful' do
      get :edit, id: shelter.id
      expect(response).to be_success
    end
  end

  describe 'POST #create' do
    context 'logged in as an admin' do
      include_context 'signed in admin'

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
        }.to_not change(Shelter, :count)
      end
    end
  end

  describe 'PUT #update' do
    let(:test_shelter) { create(:shelter, name: 'BARCS') }
    let(:request) { -> { put :update, id: test_shelter.id, shelter: attributes_for(:shelter, name: 'New Shelter') } }

    context 'logged in as admin' do
      include_context 'signed in admin'

      it 'updates the shelter name' do
        expect { request.call }.to change { test_shelter.reload.name }.from('BARCS').to('New Shelter')
      end
    end

    context 'logged in as normal user' do
      before :each do
        allow(controller).to receive(:current_user) { hacker }
      end

      it 'is unable to modify shelter' do
        expect { request.call }.to_not change { test_shelter.reload.name }
      end
    end
  end
end
