require 'rails_helper'

feature 'manage medical and behavior summaries', js: true do
  let!(:admin) { create(:user, :admin) }
  let!(:test_dog) { create(:dog, :status => 'adoptable') }

  context 'Logged in as Admin' do
    before(:each) do
      sign_in_as(admin)
    end

    scenario 'Edit Medical Summary' do
      visit '/dogs'
      expect(page).to have_content(test_dog.name.titleize)

      click_link(test_dog.name)
      click_link('Edit Dog')
      fill_in('dog_medical_summary', with: 'Medical records up to date.')
      click_button('Submit')
      expect(page).to have_content('Medical records up to date.')
    end

    scenario 'Edit Behavior Summary' do
      visit '/dogs'
      expect(page).to have_content(test_dog.name.titleize)

      click_link(test_dog.name)
      click_link('Edit Dog')
      fill_in('dog_behavior_summary', with: 'The dog has ADHD.')
      click_button('Submit')
      expect(page).to have_content('The dog has ADHD.')
    end
  end

end
