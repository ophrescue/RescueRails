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
          expect(page).to have_selector('.alert.alert-danger h4', text: "Sorry, this dog is no longer available for adoption!")
          expect(page).to have_selector('.alert.alert-danger', text: "Please see our gallery of")
          expect(page).to have_selector('.alert.alert-danger a', text: "available dogs")
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

  context 'dog does not have any photos' do
    before(:each) do
      visit dog_path(adoptable_dog)
    end

    let(:adoptable_dog){ FactoryBot.create(:dog, status: 'adoptable') }
    it "should show the no_photo image" do
      expect(page.find("#galleria .galleria-images .galleria-image img")["src"]).to match(/assets\/no_photo/)
    end
  end

  context 'dog has photos' do
    before(:each) do
      visit dog_path(adoptable_dog)
    end

    let(:adoptable_dog){ FactoryBot.create(:dog, :with_photos, status: 'adoptable') }
    let(:thumbnails){ adoptable_dog.photos.collect { |photo| photo.photo.url(:medium) } }
    let(:first_position_photo_url){ adoptable_dog.photos.find{|p| p.position == 1}.photo.url(:original) }
    let(:main_image_source){ page.find("#galleria .galleria-images .galleria-image img")["src"] }
    let(:thumbnail_sources){ page.all("#galleria .galleria-thumbnails .galleria-image img").map{|img| img["src"]} }

    it "should show the first position photo" do
      expect(main_image_source).to match(first_position_photo_url)
    end

    it "should show the lower position photos as thumbnails" do
      thumbnail_sources.each_with_index do |src,i|
        expect(src).to match(thumbnails[i])
      end
    end # / it
  end # / context
end # /feature
