require 'rails_helper'

feature 'manage medical and behavior summaries', js: true do
  
  scenario 'Edit Medical Summary' do
    test_dog = create(:dog)
    visit '/dogs'
    expect(page).to have_content(test_dog.name.titleize)
    click_button('Edit Dog')
    fill_in('medical_summary', with: "Medical records up to date.")
    click_button('Submit')
    expect(page).to have_content("Medical records up to date.")
    
  end
  scenario "Edit Behavior Summary" do
    test_dog = create(:dog)
    visit '/dogs'
    expect(page).to have_content(test_dog.name.titleize)
    click_button('Edit Dog')
    fill_in('behavior_summary', with: "He has ADHD.")
    click_button('Submit')
    expect(page).to have_content("He has ADHD.")
    
  end 
end 