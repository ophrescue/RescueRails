require 'rails_helper'

describe CampaignsController, type: :controller do
  describe 'GET #index' do
    it 'is successful' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    let(:campaign) { create(:campaign) }

    it 'is successful with valid id param' do
      get :show, params: { id: campaign.id }
      expect(response).to be_successful
      expect(assigns[:campaign]).to eq campaign
    end

    it 'is unsuccessful with invalid id param' do
      expect{ get :show, params: { id: 'hack_me_if_you_can' } }.to raise_exception ActiveRecord::RecordNotFound
      expect(assigns[:campaign]).to be_nil
    end
  end

  describe 'GET #new' do
    include_context 'signed in event manager'

    it 'is successful' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    include_context 'signed in event manager'

    let(:campaign) { create(:campaign) }

    it 'is successful' do
      get :edit, params: { id: campaign.id }
      expect(response).to be_successful
    end
  end

  describe 'PUT #update' do
    include_context 'signed in event manager'

    let(:campaign) { create(:campaign) }

    it 'is successful' do
      put :update, params: { id: campaign.id, campaign: { title: 'New Campaign Name' } }
      expect(flash[:success]).to eq "Campaign Updated"
      expect(response).to redirect_to campaigns_path
    end
  end

  describe 'POST #create' do
    include_context 'signed in event manager'

    it 'is successful' do
      post :create, params: { campaign: attributes_for(:campaign) }
      expect(flash[:success]).to eq "New Campaign Added"
      expect(response).to redirect_to campaigns_path
    end
  end

end
