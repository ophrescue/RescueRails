require 'rails_helper'

feature 'Add Adopters to Waitlist', js: true do
  let!(:waitlist) { create(:waitlist, name:'Puppy Waitlist') }

  scenario 'Add Adopter' do
    admin = create(:user, :admin)
    adopter = create(:adopter_with_app)

    sign_in(admin)

    visit '/waitlists'
    expect(page).to have_content('Puppy Waitlist')

    click_link(waitlist.name)
    expect(page).to have_content('Add Adopter')

    select adopter.name, from: 'Add adopter to the waitlist'
    click_button('Add Adopter')
    expect(page).to have_content('1')
    expect(page).to have_content(adopter.name)

    accept_confirm do
      click_button('X')
    end
    expect(page).to have_css("tbody#adopters_sort tr", :count=>0)
  end

end
