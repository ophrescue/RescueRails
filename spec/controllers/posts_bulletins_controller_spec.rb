# == Schema Information
#
# Table name: bulletins
#

require 'rails_helper'

describe Posts::BulletinsController, type: :controller do
  describe 'GET #index' do
    include_context 'signed in admin'
    it 'is successful' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    include_context 'signed in admin'
    let(:bulletin) { create(:bulletin) }
    it 'is successful' do
      get :show, params: { id: bulletin.id }

      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    include_context 'signed in admin'
    it 'is successful' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    include_context 'signed in admin'
    let(:bulletin) { create(:bulletin) }
    it 'is successful' do
      get :edit, params: { id: bulletin.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'logged in as an admin' do
      include_context 'signed in admin'
      it 'is able to create a bulletin' do
        expect{
          post :create, params: { bulletin: attributes_for(:bulletin) }
        }.to change(Bulletin, :count).by(1)
      end
    end

    context 'logged in as normal user' do
      include_context 'signed in user'
      it 'is unable to create a bulletin' do
        expect{
          post :create, params: { bulletin: attributes_for(:bulletin) }
        }.to_not change(Bulletin, :count)
      end
    end
  end

  describe 'PUT #update' do
    let(:test_bulletin) { create(:bulletin, title: 'old title') }
    let(:request) { -> { put :update, params: { id: test_bulletin.id, bulletin: attributes_for(:bulletin, title: 'new hotness') } } }

    context 'logged in as admin' do
      include_context 'signed in admin'
      it 'updates the bulletin name' do
        expect { request.call }.to change { test_bulletin.reload.title }.from('old title').to('new hotness')
      end
    end

    context 'logged in as normal user' do
      include_context 'signed in user'
      it 'is unable to modify bulletin' do
        expect { request.call }.to_not change { test_bulletin.reload.title }
      end
    end
  end
end
