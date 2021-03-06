require 'rails_helper'

feature 'manage medical and behavior summaries', js: true do
  let!(:test_dog) { create(:dog, :status => 'adoptable') }

  context 'Logged in as Admin' do
    before(:each) do
      sign_in_as_admin
    end

    scenario 'Edit Dog Summaries' do
      visit dogs_manager_index_path
      expect(page).to have_content(test_dog.name)

      click_link(test_dog.name)
      click_link('Edit')
      fill_in('dog_medical_summary', with: 'Medical records up to date.')
      fill_in('dog_behavior_summary', with: 'The dog has ADHD.')
      fill_in('dog_wait_list', with: 'I am next in line')
      click_button('Submit')
      expect(page).to have_content('Medical records up to date.')
      expect(page).to have_content('The dog has ADHD.')
      expect(page).to have_content('I am next in line')
    end
  end
end
