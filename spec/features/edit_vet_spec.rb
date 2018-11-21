require 'rails_helper'

feature 'Edit Vet Info Form', js: true do
  let!(:adopter) { create(:adopter, :with_app) }

  scenario 'Admin is able to edit vet info' do

    sign_in_as_admin
    visit adopter_path(adopter)

    click_link('Pet Vet')
    expect(page).to have_content(adopter.adoption_app.current_pets)

    expect(first('.vet-read-only', visible: false)).to be_visible
    expect(first('.vet-editable', visible: false)).not_to be_visible

    find('#toggle-edit-vet').click

    expect(first('.vet-read-only', visible: false)).not_to be_visible
    expect(first('.vet-editable', visible: false)).to be_visible

    find('#toggle-edit-vet').click

    expect(first('.vet-read-only', visible: false)).to be_visible
    expect(first('.vet-editable', visible: false)).not_to be_visible
  end

  scenario 'Admin edits vet info' do

    sign_in_as_admin
    visit adopter_path(adopter)

    click_link('Pet Vet')
    expect(page).to have_content(adopter.adoption_app.current_pets)

    find('#toggle-edit-vet').click
    fill_in('adoption_app_current_pets', with: 'Fluffy Ole Puppers')
    click_button('Save Vet Info')

    click_link('Pet Vet')
    expect(page).to have_content('Fluffy Ole Puppers')
  end
end
