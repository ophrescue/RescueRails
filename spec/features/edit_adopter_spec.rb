require 'rails_helper'

feature 'Edit Adopter Form', js: true do
  let!(:admin) { create(:user, :admin) }
  let!(:adopter) { create(:adopter_with_app) }

  scenario 'Admin edits adopter' do
    sign_in(admin)
    visit adopter_path(adopter)

    expect(page).to have_content(adopter.name)
    expect(page).to have_content(adopter.email)

    expect(first('.read-only', visible: false)).to be_visible
    expect(first('.editable', visible: false)).not_to be_visible

    find('#toggle-edit').click

    expect(first('.read-only', visible: false)).not_to be_visible
    expect(first('.editable', visible: false)).to be_visible

    find('#toggle-edit').click

    expect(first('.read-only', visible: false)).to be_visible
    expect(first('.editable', visible: false)).not_to be_visible
  end
end
