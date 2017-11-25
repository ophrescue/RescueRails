require 'rails_helper'

feature 'Edit Adopter Form', js: true do
  let!(:admin) { create(:user, :admin) }
  let!(:adopter) { create(:adopter_with_app) }

  scenario 'Admin edits adopter' do
    sign_in(admin)
    visit adopter_path(adopter)

    expect(page).to have_content(adopter.name)
    expect(page).to have_content(adopter.email)

    expect(first('.read-only').visible?).to be true
    expect(first('.editable')).to be_nil

    find('#toggle-edit').click

    expect(first('.read-only')).to be_nil
    expect(first('.editable').visible?).to be true

    find('#toggle-edit').click

    expect(first('.read-only').visible?).to be true
    expect(first('.editable')).to be_nil
  end
end
