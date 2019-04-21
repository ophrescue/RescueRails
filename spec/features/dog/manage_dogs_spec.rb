require 'rails_helper'
require_relative '../../helpers/application_helpers'

feature 'View Dogs', js: true do
  include ApplicationHelpers
  let!(:test_foster) { create(:user) }
  let!(:test_dog) { create(:dog_with_photo_and_attachment, name: "Couch potato", foster_id: test_foster.id, status: 'adoptable') }

  context 'Logged in as Admin' do
    before(:each) do
      sign_in_as_admin
    end

    scenario 'can view the Manager View' do
      visit dogs_manager_index_path
      expect(page).to have_content(test_dog.name)
    end

    scenario 'can view private information about a dog' do
      visit dogs_manager_path(test_dog)
      expect(page).to have_content(test_dog.name)
      ["Medical Summary",
       "Behavior Summary",
       "Original Name",
       "Microchip",
       "Adoption Fee",
       "OK with dogs?",
       "OK with cats?",
       "OK with kids?",
       "Medical Review Complete",
       "Has Medical Need",
       "Needs Spay or Neuter",
       "High Priority",
       "Needs Photos",
       "Has Behavior Problem",
       "Needs Foster",
       "Foster",
       "Adoption Coordinator",
       "Source Shelter",
       "Adopters",
       "Available on",
       "Intake date",
       "Adopted on",
       "Ads",
       "Up-to-date on shots",
       "First shots",
       "Second shots",
       "Third shots",
       "Rabies",
       "4DX",
       "Bordetella",
       "Heartworm Preventative",
       "Flea/Tick Preventative",
       "Dewormer",
       "Toltrazuril"].each do |private_info|
        expect(page).to have_content private_info
      end
    end

    scenario 'can view the public dog gallery' do
      visit dogs_path
      expect(page).to have_content(test_dog.name)
      click_link(test_dog.name)
      expect(page).to have_content(test_dog.name)
    end
  end

  context 'Logged in as Active User' do
    before(:each) do
      sign_in_as_user
    end

    scenario 'can view the Manager View' do
      visit dogs_manager_index_path
      expect(page).to have_content(test_dog.name)
    end

    scenario 'can view private information about a dog' do
      visit dogs_manager_path(test_dog)
      expect(page).to have_content(test_dog.name)
      ["Medical Summary",
       "Behavior Summary",
       "Original Name",
       "Microchip",
       "Adoption Fee",
       "OK with dogs?",
       "OK with cats?",
       "OK with kids?",
       "Medical Review Complete",
       "Has Medical Need",
       "Needs Spay or Neuter",
       "High Priority",
       "Needs Photos",
       "Has Behavior Problem",
       "Needs Foster",
       "Foster",
       "Adoption Coordinator",
       "Source Shelter",
       "Adopters",
       "Available on",
       "Intake date",
       "Adopted on",
       "Ads",
       "Up-to-date on shots",
       "First shots",
       "Second shots",
       "Third shots",
       "Rabies",
       "4DX",
       "Bordetella",
       "Heartworm Preventative",
       "Flea/Tick Preventative",
       "Dewormer",
       "Toltrazuril"].each do |private_info|
        expect(page).to have_content private_info
      end
    end

    scenario 'can view the public dog gallery' do
      visit dogs_path
      expect(page).to have_content(test_dog.name)
      click_link(test_dog.name)
      expect(page).to have_content(test_dog.name)
    end
  end

  context 'Logged in as Inactive User' do
    before do
      sign_in_as_inactive_user
    end

    scenario 'cannot view the Manager View' do
      visit dogs_manager_index_path
      expect(page_heading).to eq 'Our Dogs'
    end

    scenario 'can not view private information about a dog' do
      visit dogs_manager_index_path(test_dog)
      expect(page).to have_content(test_dog.name)
      ["Medical Summary",
       "Behavior Summary",
       "Original Name",
       "Microchip",
       "Adoption Fee",
       "OK with dogs?",
       "OK with cats?",
       "OK with kids?",
       "Medical Review Complete",
       "Has Medical Need",
       "Needs Spay or Neuter",
       "High Priority",
       "Needs Photos",
       "Has Behavior Problem",
       "Needs Foster",
       "Foster",
       "Adoption Coordinator",
       "Source Shelter",
       "Adopters",
       "Available on",
       "Intake date",
       "Adopted on",
       "Ads",
       "Up-to-date on shots",
       "First shots",
       "Second shots",
       "Third shots",
       "Rabies",
       "4DX",
       "Bordetella",
       "Heartworm Preventative",
       "Flea/Tick Preventative",
       "Dewormer",
       "Toltrazuril"].each do |private_info|
        expect(page).to have_no_content private_info
      end
    end

    scenario 'can view the public dog gallery' do
      visit dogs_path
      expect(page).to have_content(test_dog.name)
      click_link(test_dog.name)
      expect(page).to have_content(test_dog.name)
    end
  end

  context 'Not Logged In' do
    scenario 'can not use the Manager View' do
      visit dogs_manager_index_path
      expect(page_heading).to eq "Staff Sign in"
    end

    scenario 'can view the public dog gallery' do
      visit dogs_path
      expect(page).to have_content(test_dog.name)
      click_link(test_dog.name)
      expect(page).to have_content(test_dog.name)
    end
  end
end
