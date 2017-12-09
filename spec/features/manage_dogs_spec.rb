require 'rails_helper'

feature 'View Dogs', js: true do
  let!(:admin) { create(:user, :admin) }
  let!(:active_user) { create(:user) }
  let!(:inactive_user) { create(:user, :inactive_user) }
  let!(:test_foster) { create(:user) }
  let!(:test_dog) { create(:dog_with_photo_and_attachment, foster_id: test_foster.id) }

  context 'Logged in as Admin' do
    before(:each) do
      sign_in(admin)
    end

    scenario 'can view the Manager View' do
      visit '/dogs'
      click_link("Manager View")
      expect(page).to have_content(test_dog.name.titleize)
    end

    scenario 'can view private information about a dog' do
      visit dog_path(test_dog)
      expect(page).to have_content(test_dog.name.titleize)
      expect(page).to have_content('Medical Summary')
      expect(page).to have_content('Behavior Summary')
      expect(page).to have_content('Private Information')
    end

    scenario 'can view the public dog gallery' do
      visit '/dogs'
      expect(page).to have_content(test_dog.name.titleize)
      click_link(test_dog.name.titleize)
      expect(page).to have_content(test_dog.name.titleize)
    end

  end

  context 'Logged in as Active User' do
    before(:each) do
      sign_in(active_user)
    end

    scenario 'can view the Manager View' do
      visit '/dogs'
      click_link("Manager View")
      expect(page).to have_content(test_dog.name.titleize)
    end

    scenario 'can view private information about a dog' do
      visit dog_path(test_dog)
      expect(page).to have_content(test_dog.name.titleize)
      expect(page).to have_content('Medical Summary')
      expect(page).to have_content('Behavior Summary')
      expect(page).to have_content('Private Information')
    end

    scenario 'can view the public dog gallery' do
      visit '/dogs'
      expect(page).to have_content(test_dog.name.titleize)
      click_link(test_dog.name.titleize)
      expect(page).to have_content(test_dog.name.titleize)
    end
  end

  context 'Logged in as Inactive User' do
    before(:each) do
      sign_in(inactive_user)
    end

    scenario 'cannot view the Manager View' do
      visit '/dogs'
      expect(page).to have_no_content('Manager View')
    end

    scenario 'can not view private information about a dog' do
      visit dog_path(test_dog)
      expect(page).to have_content(test_dog.name.titleize)
      expect(page).to have_no_content('Medical Summary')
      expect(page).to have_no_content('Behavior Summary')
      expect(page).to have_no_content('Private Information')
    end

    scenario 'can view the public dog gallery' do
      visit '/dogs'
      expect(page).to have_content(test_dog.name.titleize)
      click_link(test_dog.name.titleize)
      expect(page).to have_content(test_dog.name.titleize)
    end
  end

  context 'Not Logged In' do
    scenario 'can not use the Manager View' do
      visit '/dogs'
      expect(page).to have_no_content('Manager View')
    end

    scenario 'can not view private information about a dog' do
      visit dog_path(test_dog)
      expect(page).to have_content(test_dog.name.titleize)
      expect(page).to have_no_content('Medical Summary')
      expect(page).to have_no_content('Behavior Summary')
      expect(page).to have_no_content('Private Information')
    end

    scenario 'can view the public dog gallery' do
      visit '/dogs'
      expect(page).to have_content(test_dog.name.titleize)
      click_link(test_dog.name.titleize)
      expect(page).to have_content(test_dog.name.titleize)
    end
  end

end
