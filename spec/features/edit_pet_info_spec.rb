require 'rails_helper'

feature 'Edit Pet Info Form', js: true do
    let!(:adopter) {create(:adopter, :with_app) }

    scenario "Admin is able to edit pet info", js: true do

        sign_in_as_admin
        visit adopter_path(adopter)

        click_link('Pet Info')
        expect(page).to have_content(adopter.adoption_app.building_type)

        expect(first('.info-read-only', visible: false)).to be_visible
        expect(first('.info-editable', visible: false)).not_to be_visible

        find('#toggle-edit-info').click

        expect(first('.info-read-only', visible: false)).not_to be_visible
        expect(first('.info-editable', visible: false)).to be_visible

        find('#toggle-edit-info').click

        expect(first('.info-read-only', visible: false)).to be_visible
        expect(first('.info-editable', visible: false)).not_to be_visible
   
    end

    scenario "Admin edits pet info", js: true do

        sign_in_as_admin

        visit adopter_path(adopter)
        click_link('Pet Info')

        expect(page).to have_content(adopter.adoption_app.building_type)

        find('#toggle-edit-info').click
        select('Farm', from: 'adoption_app_building_type')
        click_button('Save Pet Info')

        click_link('Pet Info')
        expect(page).to have_content('Farm')
    end
end
