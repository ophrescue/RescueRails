require 'rails_helper'
require_relative '../helpers/dog_show_helper'

feature 'visit dog show page', js: true do
  include DogShowHelper
  let!(:active_user) { create(:user) }

  before do
    sign_in(active_user)
  end

  context "dog is unavailable" do
    before(:each) do
      visit dogs_manager_path(adoption_completed_dog)
    end

    ["adopted", "completed", "not available"].each do |status|
      context "when the dog adoption is #{status}" do
        let(:adoption_completed_dog){FactoryBot.create(:dog, status: status)}
        it 'should show alert to inform user' do
          expect(page).to have_selector('.alert.alert-error h4', text: "Sorry, this dog is no longer available for adoption!")
          expect(page).to have_selector('.alert.alert-error', text: "Please see our gallery of")
          expect(page).to have_selector('.alert.alert-error a', text: "available dogs")
        end
      end
    end
  end

  context "adoptapet ad text" do
    before(:each) do
      visit dogs_manager_path(dog)
    end

    context "dog does not have a foster" do
      let(:dog){ FactoryBot.create(:dog, foster_id: nil) }

      it "should indicate Adoptapet ad needs foster" do
        expect(adoptapet_ad).to eq "Foster needed for Adoptapet"
      end
    end

    context "dog foster is out-of-region" do
      let(:foster){ FactoryBot.create(:foster, region: "CA") }
      let(:dog){ FactoryBot.create(:dog, foster_id: foster.id) }

      it "should indicate Adoptapet N/A" do
        expect(adoptapet_ad).to eq "Adoptapet N/A for CA"
      end
    end

    context "dog foster is in-region" do
      let(:region){ "VA" }
      let(:foster){ FactoryBot.create(:foster, region: region) }
      let(:dog){ FactoryBot.create(:dog, foster_id: foster.id) }

      it "should have a link to the Adoptapet ad" do
        expect(adoptapet_ad_link).to eq Adoptapet.new(region).url
        expect(page).to have_selector("#adoptapet_ad a", text: "Adoptapet VA")
      end
    end
  end
end
