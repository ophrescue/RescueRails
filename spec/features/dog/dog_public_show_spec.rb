require 'rails_helper'
require_relative '../../helpers/animal_show_helper'

xfeature 'visit dog show page', js: true do
  include AnimalShowHelper

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

    # disabling for now due to flaky behavior
    # it "should show the lower position photos as thumbnails" do
    #   thumbnail_sources.each_with_index do |src,i|
    #     expect(src).to match(thumbnails[i])
    #   end
    # end
  end

end
