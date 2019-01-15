require 'rails_helper'

feature "Home Page" do
  scenario "Home page is available" do
    visit root_path

    expect(page).to have_content 'Operation Paws for Homes'
  end
end
