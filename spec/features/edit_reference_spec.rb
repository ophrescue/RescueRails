require 'rails_helper'

feature 'Edit Reference Form', js: true do
  let!(:admin) { create(:user, :admin) }
  let!(:adopter) { create(:adopter_with_app) }

  scenario 'Admin edits reference' do
    reference = FactoryBot.create(:reference, adopter: adopter)

    sign_in(admin)
    visit adopter_path(adopter)

    expect(page).to have_content(adopter.name)
    expect(page).to have_content(adopter.email)

    click_link('References')
    expect(page).to have_field("adopter_references_attributes_0_name", with: reference.name)
    expect(page).to have_field("adopter_references_attributes_0_email", with: reference.email)
    expect(page).to have_field("adopter_references_attributes_0_whentocall", with: reference.whentocall)

    fill_in('adopter_references_attributes_0_name', with: 'First Reference')
    within(:css, "#references") do
      click_button('Save')
    end

    expect(page).to have_content('Application Updated')

    click_link('References')
    expect(page).to have_field("adopter_references_attributes_0_name", with: 'First Reference')

    expect(page).to have_content("#{admin.name} has changed name from #{reference.name} to First Reference")
  end
end
