require 'rails_helper'

feature "Home Page" do
  scenario "Home page is available to a signed in user" do
    sign_in_as_admin
    visit root_path

    expect(page).to have_content 'Operation Paws for Homes'
  end

  scenario "Home page requires login for a public user" do
    visit root_path

    expect(current_path).to eq sign_in_path
  end
end
