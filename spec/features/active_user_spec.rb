require 'rails_helper'

feature 'two levels of volunteer', js:true do
  let(:admin) {create(:user, :admin) }
  scenario 'Not an Active Volunteer' do
    sign_in(admin)
    click_on('staff')
    expect(page).to not_have_content('DNA List')
    expect(page).to not_have_content('Manage Dogs')
    expect(page).to not_have_content('Users')
    
    visit '/dogs'
    expect(page).to not_have_content('Manager View')
  end 
end