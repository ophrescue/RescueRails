require 'rails_helper'
require_relative '../helpers/dog_show_helper'

feature 'visit dog show page', js: true do
  include DogShowHelper
  context "dog is unavailable" do
    before(:each) do
      visit dogs_gallery_path(adoption_completed_dog)
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
end
