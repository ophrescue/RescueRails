require 'rails_helper'

feature 'visit dog show page', js: true do
  context 'dog is no longer available' do
    before(:each) do
      visit dog_path(adoption_completed_dog)
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
      `mkdir -p #{Rails.root.join("public","system","dog_photo")}`
      3.times do |i|
        photo = FactoryBot.create(:photo, dog: adoptable_dog, is_private: false, position: i+1 )
        ["medium", "original"].each do |style|
          data = "photos/photos/#{photo.id}/#{style}/"
          hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA1.new, Photo::HASH_SECRET, data)
          filepath = "public/system/dog_photo/#{hash}.jpg"
          image_source = Rails.root.join('spec','fixtures','photo','dog_pic.jpg').to_s
          `cp #{image_source} #{Rails.root.join(filepath)}`
        end
      end
      visit dog_path(adoptable_dog)
    end

    let(:adoptable_dog){ FactoryBot.create(:dog, status: 'adoptable') }
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
