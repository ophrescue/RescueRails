# == Schema Information
#
# Table name: cats
#
require 'rails_helper'

describe Cats::GalleryController, type: :controller do
  describe 'GET #index' do
    it 'redirects to sign in when not authenticated' do
      get :index, params: {}
      expect(response).to redirect_to('/sign_in')
    end

    it 'with autocomplete parameter redirects to sign in when not authenticated' do
      get :index, params: {autocomplete: true}
      expect(response).to redirect_to('/sign_in')
    end
  end

  describe 'GET #show' do
    let(:cat) { create(:cat, status: 'adoptable') }

    it 'redirects to sign in when not authenticated' do
      get :show, params: { id: cat.id }
      expect(response).to redirect_to('/sign_in')
    end
  end

  describe 'GET #show for an unavailable cat is NOT visible to the public' do
    let(:cat) { create(:cat, status: 'not available') }

    it 'redirects to sign in' do
      get :show, params: { id: cat.id }
      expect(response).to redirect_to('/sign_in')
    end
  end
end
