require 'rails_helper'

feature 'Reset Password' do

  let!(:admin) {create(:user, :admin)}

  scenario 'User exists' do
    visit '/password_resets/new'
    fill_in('email', with: admin.email )
    click_button('Reset Password')
    expect(page).to have_content('Email sent with password reset instructions')
  end

  scenario 'User does not exist' do
    visit '/password_resets/new'
    fill_in('email', with: 'fake@whatever.com' )
    click_button('Reset Password')
    expect(page).to have_content('Unknown Email Address')
  end

end