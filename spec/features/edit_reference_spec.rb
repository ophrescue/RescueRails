require 'rails_helper'

feature 'Edit Reference Form', js: true do
  let!(:admin) { create(:user, :admin) }
  let!(:adopter) { create(:adopter_with_app) }

  scenario 'Admin is able to edit reference' do
    reference = FactoryBot.create(:reference, adopter: adopter)

    sign_in(admin)
    visit adopter_path(adopter)

    click_link('References')
    expect(page).to have_content(reference.name)
    expect(page).to have_content(reference.email)

    expect(first('.ref-read-only').visible?).to be true
    expect(first('.ref-editable')).to be_nil

    find('#toggle-edit-ref').click

    expect(first('.ref-read-only')).to be_nil
    expect(first('.ref-editable').visible?).to be true

    find('#toggle-edit-ref').click

    expect(first('.ref-read-only').visible?).to be true
    expect(first('.ref-editable')).to be_nil
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
