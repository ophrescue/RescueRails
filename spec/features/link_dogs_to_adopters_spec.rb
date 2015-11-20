require 'rails_helper'

feature 'Link Dogs to Adoption Applications via Adoption model', js: true do
  let!(:test_applicant) {create(:adopter_with_app)}

  scenario 'Happy Path' do

    admin = create(:user, :admin)
    test_dog = create(:dog)

    visit '/signin'
    fill_in('session_email', with: admin.email )
    fill_in('session_password', with: admin.password )
    click_button('Sign in')
    expect(page).to have_content('Staff')

    visit '/adopters'
    expect(page).to have_content('Adoption Applications')

    click_link(test_applicant.name)
    expect(page).to have_content(test_applicant.name)
    expect(page).to have_no_content('status with this dog is')

    select_from_chosen(test_dog.name, from: 'adoption[dog_id]')

    click_button('Link Dog')
    expect(page).to have_content(test_applicant.name + ' status with this dog is')
    expect(page).to have_select('adoption_relation_type', selected: 'interested')


    select 'returned', from: 'adoption_relation_type'
    expect(page).to have_select('adoption_relation_type', selected: 'returned')

    click_button('X')
    expect(page).to have_no_content(test_applicant.name + ' status with this dog is')

  end

end
