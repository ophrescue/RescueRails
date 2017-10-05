require 'rails_helper'

feature 'Sign in as Admin', js: true do
  scenario 'Valid User' do
    admin = create(:user)

    visit '/signin'
    fill_in('session_email', with: admin.email)
    fill_in('session_password', with: admin.password)
    click_button('Sign in')
    expect(page).to have_no_content('Invalid')
  end
end
