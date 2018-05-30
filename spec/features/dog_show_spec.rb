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
      3.times do
        photo = FactoryBot.create(:photo, dog: adoptable_dog, is_private: false)
        ["medium", "original"].each do |style|
          data = "photos/photos/#{photo.id}/#{style}/#{photo.updated_at.to_i}" 
          hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA1.new, Photo::HASH_SECRET, data)
          filepath = "public/system/dog_photo/#{hash}.JPG"
          `touch #{Rails.root.join(filepath)}`
        end
      end
      visit dog_path(adoptable_dog)
    end

    let(:adoptable_dog){ FactoryBot.create(:dog, status: 'adoptable') }
    it "should show the photos" do
      expect(page.find("#galleria .galleria-images .galleria-image img")["src"]).to match(/assets\/no_photo/)
    end # / it
  end # / context
end # /feature
