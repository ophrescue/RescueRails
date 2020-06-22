require 'rails_helper'

feature 'Edit Rental Info Form', js: true do
    let!(:adopter) {create(:adopter, :with_app) }

    scenario "Admin is able to edit rental info", js: true do

        sign_in_as_admin
        visit adopter_path(adopter)

        click_link('Rental')
        expect(page).to have_content(adopter.adoption_app.landlord_name)

        expect(first('.rental-read-only', visible: false)).to be_visible
        expect(first('.rental-editable', visible: false)).not_to be_visible

        find('#toggle-edit-rental').click

        expect(first('.rental-read-only', visible: false)).not_to be_visible
        expect(first('.rental-editable', visible: false)).to be_visible

        find('#toggle-edit-rental').click

        expect(first('.rental-read-only', visible: false)).to be_visible
        expect(first('.rental-editable', visible: false)).not_to be_visible
   
    end

    scenario "Admin edits rental", js: true do

        sign_in_as_admin

        visit adopter_path(adopter)
        click_link('Rental')

        expect(page).to have_content(adopter.adoption_app.landlord_name)

        find('#toggle-edit-rental').click
        fill_in('adoption_app_landlord_name', with: 'The Landlord')
        click_button('Save Rental Info')

        click_link('Rental')
        expect(page).to have_content('The Landlord')
    end
end
