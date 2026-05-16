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

describe Dogs::GalleryController, type: :controller do
  describe 'GET #index' do
    subject(:get_index) { get :index, params: {} }

    it 'redirects to sign in when not authenticated' do
      get :index, params: {}
      expect(response).to redirect_to('/sign_in')
    end

    it 'with autocomplete parameter redirects to sign in when not authenticated' do
      get :index, params: {autocomplete: true}
      expect(response).to redirect_to('/sign_in')
    end
  end

  describe 'GET #show for a dog is visible to an admin' do
    include_context 'signed in admin'
    let(:dog) { create(:dog, status: 'adoptable') }

    it 'is successful' do
      get :show, params: { id: dog.id }
      expect(response).to be_successful
    end
  end

end
