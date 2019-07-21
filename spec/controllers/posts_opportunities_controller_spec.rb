require 'rails_helper'

describe Posts::OpportunitiesController, type: :controller do
  describe 'GET #index' do
    include_context 'signed in admin'
    it 'is successful' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    include_context 'signed in admin'
    let(:opportunity) { create(:opportunity) }
    it 'is successful' do
      get :show, params: { id: opportunity.id }

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
    let(:opportunity) { create(:opportunity) }
    it 'is successful' do
      get :edit, params: { id: opportunity.id }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'logged in as an admin' do
      include_context 'signed in admin'
      it 'is able to create a opportunity' do
        expect{
          post :create, params: { opportunity: attributes_for(:opportunity) }
        }.to change(Opportunity, :count).by(1)
      end
    end

    context 'logged in as normal user' do
      include_context 'signed in user'
      it 'is unable to create a opportunity' do
        expect{
          post :create, params: { opportunity: attributes_for(:opportunity) }
        }.to_not change(Opportunity, :count)
      end
    end
  end

  describe 'PUT #update' do
    let(:test_opportunity) { create(:opportunity, title: 'old title') }
    let(:request) { -> { put :update, params: { id: test_opportunity.id, opportunity: attributes_for(:opportunity, title: 'new hotness') } } }

    context 'logged in as admin' do
      include_context 'signed in admin'
      it 'updates the opportunity name' do
        expect { request.call }.to change { test_opportunity.reload.title }.from('old title').to('new hotness')
      end
    end

    context 'logged in as normal user' do
      include_context 'signed in user'
      it 'is unable to modify opportunity' do
        expect { request.call }.to_not change { test_opportunity.reload.title }
      end
    end
  end
end
