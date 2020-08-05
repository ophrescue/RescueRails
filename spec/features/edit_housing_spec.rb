require 'rails_helper'

feature 'Edit Housing Info Form', js: true do
    let!(:adopter) {create(:adopter, :with_app) }

    scenario "Admin is able to edit housing info", js: true do

        sign_in_as_admin
        visit adopter_path(adopter)

        click_link('Housing')
        expect(page).to have_content(adopter.adoption_app.landlord_name)

        expect(first('.rent-read-only', visible: false)).to be_visible
        expect(first('.rent-editable', visible: false)).not_to be_visible

        find('#toggle-edit-housing').click

        expect(first('.rent-read-only', visible: false)).not_to be_visible
        expect(first('.rent-editable', visible: false)).to be_visible

        find('#toggle-edit-housing').click

        expect(first('.rent-read-only', visible: false)).to be_visible
        expect(first('.rent-editable', visible: false)).not_to be_visible
   
    end

    scenario "Admin edits housing", js: true do

        sign_in_as_admin

        visit adopter_path(adopter)
        click_link('Housing')

        expect(page).to have_content(adopter.adoption_app.landlord_name)

        find('#toggle-edit-housing').click
        fill_in('adoption_app_landlord_name', with: 'The Landlord')
        click_button('Save Housing Info')

        click_link('Housing')
        expect(page).to have_content('The Landlord')
    end
    
    scenario "When rent house, rent info is displayed", js: true do

        adopter.adoption_app.house_type ='rent'

        sign_in_as_admin
        visit adopter_path(adopter)
    
        click_link('Housing')
        
        expect(page).to have_content(adopter.adoption_app.house_type)

    end

    scenario "When own house, rent info is not displayed", js: true do

        sign_in_as_admin
        visit adopter_path(adopter)
    
        click_link('Housing')

        find('#toggle-edit-housing').click
        page.choose(option: 'own')
        click_button('Save Housing Info')

        click_link('Housing')
        
        expect(page).not_to have_content(adopter.adoption_app.landlord_name)

    end

    scenario "May modify housing info", js: true do

        sign_in_as_admin
        visit adopter_path(adopter)
    
        click_link('Housing')

        find('#toggle-edit-housing').click
        page.choose(option: 'own')
        click_button('Save Housing Info')

        click_link('Housing')

        expect(page).to have_content('owns')

    end

end
