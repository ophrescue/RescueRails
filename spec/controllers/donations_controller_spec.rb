require 'rails_helper'

describe DonationsController, type: :controller do
  describe 'GET #index' do
    it 'redirects to donations/new' do
      get :index
      expect(response).to redirect_to(new_donation_url)
    end
  end

  describe 'GET #history as public' do
    it 'redirects to sign_in' do
      get :history
      expect(response).to redirect_to(sign_in_url)
    end
  end

  describe 'GET #history as admin' do
    include_context 'signed in admin'
    let!(:donation) { create(:donation)}

    it 'is successful' do
      get :history
      expect(response).to be_successful
    end

    it 'returns excel list of donations' do
      get :history, format: :xls
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #new' do
    it 'is successful' do
      get :new
      expect(response).to be_successful
    end
  end
end if false
