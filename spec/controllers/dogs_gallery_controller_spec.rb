# == Schema Information
#
# Table name: dogs
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  tracking_id          :integer
#  primary_breed_id     :integer
#  secondary_breed_id   :integer
#  status               :string(255)
#  age                  :string(75)
#  size                 :string(75)
#  is_altered           :boolean
#  gender               :string(6)
#  is_special_needs     :boolean
#  no_dogs              :boolean
#  no_cats              :boolean
#  no_kids              :boolean
#  description          :text
#  foster_id            :integer
#  adoption_date        :date
#  is_uptodateonshots   :boolean          default(TRUE)
#  intake_dt            :date
#  available_on_dt      :date
#  has_medical_need     :boolean          default(FALSE)
#  is_high_priority     :boolean          default(FALSE)
#  needs_photos         :boolean          default(FALSE)
#  has_behavior_problem :boolean          default(FALSE)
#  needs_foster         :boolean          default(FALSE)
#  petfinder_ad_url     :string(255)
#  adoptapet_ad_url     :string(255)
#  craigslist_ad_url    :string(255)
#  youtube_video_url    :string(255)
#  first_shots          :string(255)
#  second_shots         :string(255)
#  third_shots          :string(255)
#  rabies               :string(255)
#  heartworm            :string(255)
#  bordetella           :string(255)
#  microchip            :string(255)
#  original_name        :string(255)
#  fee                  :integer
#  coordinator_id       :integer
#  sponsored_by         :string(255)
#  shelter_id           :integer
#  medical_summary      :text
require 'rails_helper'

describe DogsGalleryController, type: :controller do
  describe 'GET #index' do
    let!(:adoptable_dog) { create(:dog, status: 'adoptable', tracking_id: 102) }
    let!(:adoption_pending_dog) { create(:dog, status: 'adoption pending', tracking_id: 105) }
    let!(:coming_soon_dog) { create(:dog, status: 'coming soon', tracking_id: 100) }

    let!(:adopted_dog) { create(:dog, status: 'adopted', tracking_id: 1) }
    let!(:on_hold_dog) { create(:dog, status: 'on hold', tracking_id: 2) }
    let!(:not_available_dog) { create(:dog, status: 'not available', tracking_id: 3) }

    subject(:get_index) { get :index, params: {} }

    it 'Only adoptable, adoption pending or coming soon dogs should be displayed in order by tracking id' do
      get_index
      expect(assigns(:dogs)).to eq([coming_soon_dog, adoptable_dog, adoption_pending_dog])
    end

    it 'with autocomplete parameter set all dogs are returned' do
      get :index, params: {autocomplete: true}
      expect(assigns(:dogs)).to match_array([adoptable_dog, adoption_pending_dog, coming_soon_dog, adopted_dog, on_hold_dog, not_available_dog])
    end
  end

  describe 'GET #show' do
    let(:dog) { create(:dog) }

    it 'is successful' do
      get :show, params: { id: dog.id }
      expect(response).to be_successful
    end
  end


end
