require 'rails_helper'

feature 'Link Cats to Adoption Applications via Adoption model', js: true do
  let!(:test_applicant) { create(:adopter, :with_app) }

  scenario 'Happy Path' do
    create(:cat, name: 'Meow')
    create(:cat, name: 'Meop')

    sign_in_as_admin

    visit '/adopters'
    expect(page).to have_content('Adoption Applications')

    click_link(test_applicant.name)
    expect(page).to have_content(test_applicant.name)
    expect(page).to have_no_content('status with this cat is')

    select_from_autocomplete('autocomplete_label', with: 'Meo', click: 'Meow')

    click_button('Link Cat')
    expect(page).to have_content(test_applicant.name + ' status with this cat is', wait: 5)
    expect(page).to have_select('adoption_relation_type', selected: 'interested')

    select 'returned', from: 'adoption_relation_type'
    expect(page).to have_select('adoption_relation_type', selected: 'returned')

    accept_confirm do
      click_button('X')
    end

    expect(page).to have_no_content(test_applicant.name + ' status with this cat is')
  end
end
