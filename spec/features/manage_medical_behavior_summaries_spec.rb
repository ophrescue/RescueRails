require 'rails_helper'

feature 'manage medical and behavior summaries', js: true do
  let(:admin) { create(:user, :admin) }
  scenario 'Edit Medical Summary' do
    test_dog = create(:dog)
    sign_in(admin)

    visit '/dogs'
    expect(page).to have_content(test_dog.name.titleize)

    click_link(test_dog.name)
    click_link('Edit Dog')

    fill_in('dog_medical_summary', with: 'Medical records up to date.')
    click_button('Submit')
    expect(page).to have_content('Medical records up to date.')
  end
  
  
  scenario 'Edit Behavior Summary' do
    test_dog = create(:dog)
    sign_in(admin)

    visit '/dogs'
    expect(page).to have_content(test_dog.name.titleize)

    click_link(test_dog.name)
    click_link('Edit Dog')

    fill_in('dog_behavior_summary', with: 'The dog has ADHD.')
    click_button('Submit')
    expect(page).to have_content('The dog has ADHD.')
  end 
end 