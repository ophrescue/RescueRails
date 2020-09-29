require 'rails_helper'

feature 'Edit Pet Choices Form', js: true do
    let!(:adopter) {create(:adopter, :with_app) }

    scenario "Admin is able to edit pet choices", js: true do

        sign_in_as_admin
        visit adopter_path(adopter)

        expect(page).to have_content(adopter.dog_or_cat)

        expect(first('.pet-choices-read-only', visible: false)).to be_visible
        expect(first('.pet-choices-editable', visible: false)).not_to be_visible

        find('#toggle-edit-pet-choices').click

        expect(first('.pet-choices-read-only', visible: false)).not_to be_visible
        expect(first('.pet-choices-editable', visible: false)).to be_visible

        find('#toggle-edit-pet-choices').click

        expect(first('.pet-choices-read-only', visible: false)).to be_visible
        expect(first('.pet-choices-editable', visible: false)).not_to be_visible
   
    end

    scenario "Admin edits pet choices", js: true do

        sign_in_as_admin

        visit adopter_path(adopter)

        expect(page).to have_content(adopter.dog_or_cat)

        find('#toggle-edit-pet-choices').click
        select('Dog', from: 'adopter_dog_or_cat')
        click_button('Save Pet Choices')

        expect(page).to have_content('Dog')
    end
end
