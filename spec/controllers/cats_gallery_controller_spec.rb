# == Schema Information
#
# Table name: cats
#
require 'rails_helper'

describe Cats::GalleryController, type: :controller do
  describe 'GET #index' do
    let!(:adoptable_cat) { create(:cat, status: 'adoptable', tracking_id: 102) }
    let!(:adoption_pending_cat) { create(:cat, status: 'adoption pending', tracking_id: 99) }
    let!(:adoption_pending_cat2) { create(:cat, status: 'adoption pending', tracking_id: 105) }
    let!(:coming_soon_cat) { create(:cat, status: 'coming soon', tracking_id: 100) }
    let!(:coming_soon_cat2) { create(:cat, status: 'coming soon', tracking_id: 109) }
    let!(:adoptable_cat2) { create(:cat, status: 'adoptable', tracking_id: 110) }

    let!(:adopted_cat) { create(:cat, status: 'adopted', tracking_id: 1) }
    let!(:on_hold_cat) { create(:cat, status: 'on hold', tracking_id: 2) }
    let!(:not_available_cat) { create(:cat, status: 'not available', tracking_id: 3) }

    subject(:get_index) { get :index, params: {} }

    it 'Only adoptable, coming soon and adoption pending cats should be displayed respectively in order by status then tracking id' do
      get_index
      expect(assigns(:cats)).to eq([adoptable_cat, adoptable_cat2, coming_soon_cat, coming_soon_cat2, adoption_pending_cat, adoption_pending_cat2])
    end

    it 'with autocomplete parameter set all cats are returned' do
      get :index, params: {autocomplete: true}
      expect(assigns(:cats)).to match_array([adoptable_cat, adoptable_cat2, adoption_pending_cat, adoption_pending_cat2, coming_soon_cat, coming_soon_cat2, adopted_cat, on_hold_cat, not_available_cat])
    end
  end

  describe 'GET #show' do
    let(:cat) { create(:cat) }

    it 'is successful' do
      get :show, params: { id: cat.id }
      expect(response).to be_successful
    end
  end


end
