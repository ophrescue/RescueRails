require 'rails_helper'

feature 'Edit Reference Form', js: true do
  let!(:admin) { create(:user, :admin) }
  let!(:adopter) { create(:adopter, :with_app) }

  scenario 'Admin is able to edit reference' do
    reference = FactoryBot.create(:reference, adopter: adopter)

    sign_in(admin)
    visit adopter_path(adopter)

    click_link('References')
    expect(page).to have_content(reference.name)
    expect(page).to have_content(reference.email)

    expect(first('.ref-read-only', visible: false)).to be_visible
    expect(first('.ref-editable', visible: false)).not_to be_visible

    find('#toggle-edit-ref').click

    expect(first('.ref-read-only', visible: false)).not_to be_visible
    expect(first('.ref-editable', visible: false)).to be_visible

    find('#toggle-edit-ref').click

    expect(first('.ref-read-only', visible: false)).to be_visible
    expect(first('.ref-editable', visible: false)).not_to be_visible
  end

  scenario 'Admin edits reference' do
    reference = FactoryBot.create(:reference, adopter: adopter)

    sign_in(admin)
    visit adopter_path(adopter)

    click_link('References')
    expect(page).to have_content(reference.name)
    expect(page).to have_content(reference.email)

    find('#toggle-edit-ref').click
    fill_in('adopter_references_attributes_0_name', with: 'First Reference')
    within(:css, "#references") do
      click_button('Save References')
    end

    expect(page).to have_content('Application Updated')

    click_link('References')
    expect(page).to have_content('First Reference')
  end
end
