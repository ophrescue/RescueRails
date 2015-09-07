require 'rails_helper'

feature "Home Page" do
  scenario "visitor can view events" do
    visit root_path

    expect(page).to have_content 'Operation Paws for Homes'
    expect(page).to have_content 'Apply for Adoption'
  end
end
