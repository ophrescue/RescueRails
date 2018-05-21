require 'rails_helper'

feature 'View a mostly nil Adoption App without crashing', js: true do
  let!(:adopter_with_null_app) { create(:adopter_with_null_app) }

  scenario "Adoptor barely fills out adoption application" do
    sign_in_as_admin

    visit '/adopters'
    expect(page).to have_content('Adoption Applications')
    click_link(adopter_with_null_app.name)
    expect(page).to have_content(adopter_with_null_app.name)
  end
end
