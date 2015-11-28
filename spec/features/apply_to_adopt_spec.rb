require 'rails_helper'

feature 'Apply for Adoption' do
  let!(:admin) {create(:user, :admin)}

  scenario "Renter fills out adoption application", js: true do

    visit root_path
    click_link 'Apply for Adoption'
    check('adopter_pre_q_costs')
    check('adopter_pre_q_surrender')
    check('adopter_pre_q_abuse')
    check('adopter_pre_q_limited_info')
    check('adopter_pre_q_breed_info')
    check('adopter_pre_q_reimbursement')

    click_button('Next')

    expect(page).to have_content('Contact Information')
    fill_in('adopter_name', with: 'Test Adopter')
    fill_in('adopter_email', with: 'fake@ophrescue.org')
    fill_in('adopter_address1', with: '642 S Ellwood Ave')
    fill_in('adopter_address2', with: 'Apt 3')
    fill_in('adopter_city', with: 'Baltimore')
    fill_in('adopter_state', with: 'MD')
    fill_in('adopter_zip', with: '21224')

    find('input#adopter_phone').trigger('click')
    sleep(1)  #TODO fix this dirty hack
    send_keys_inputmask('input#adopter_phone', '1234567890')

    find('input#adopter_other_phone').trigger('click')
    sleep(1)  #TODO fix this dirty hack
    send_keys_inputmask('input#adopter_other_phone', '0987654321')

    fill_in('adopter_when_to_call', with: 'Anytime After 3pm')
    fill_in('adopter_adoption_app_attributes_spouse_name', with: 'Miss Watir')
    fill_in('adopter_adoption_app_attributes_other_household_names', with: 'Rachel 29, Morgan 24')
    fill_in('adopter_adoption_app_attributes_how_did_you_hear', with: 'Google and Craigslist')
    fill_in('adopter_adoption_app_attributes_ready_to_adopt_dt', with: '2012-12-13')
    choose('adopter_adoption_app_attributes_is_ofage_true')
    choose('adopter_adoption_app_attributes_house_type_rent')

    click_button('Next')
    expect(page).to have_content("Landlord's Name")
    fill_in('adopter_adoption_app_attributes_landlord_name', with: 'Jane LandLord')
    send_keys_inputmask('input#adopter_adoption_app_attributes_landlord_phone', '5704431234')
    fill_in('adopter_adoption_app_attributes_rent_dog_restrictions', with: 'No dogs over 50 lbs')
    fill_in('adopter_adoption_app_attributes_rent_costs', with: 'Rent Goes Up $50 a month')

    click_button('Next')
    expect(page).to have_content('Your New Dog')
    fill_in('adopter_dog_name', with: 'Rex and Precious')
    fill_in('adopter_dog_reqs', with: 'Dog Under 50lbs')
    fill_in('adopter_why_adopt', with: 'Want to love them and hold them')
    fill_in('adopter_adoption_app_attributes_dog_exercise', with: 'Dog will go to the gym with me')
    choose('adopter_adoption_app_attributes_dog_stay_when_away_in_a_crate')
    select('4', from: 'adopter_adoption_app_attributes_max_hrs_alone')
    fill_in('adopter_adoption_app_attributes_dog_vacation', with: 'Dog will come with us on vacation')
    fill_in('adopter_adoption_app_attributes_training_explain', with: 'We will take the dog to training')
    fill_in('adopter_adoption_app_attributes_surrender_pet_causes', with: 'Would surrender if dog robbed a bank')
    fill_in('adopter_adoption_app_attributes_surrendered_pets', with: 'I never surrendered my pets')
    choose('adopter_adoption_app_attributes_pets_branch_other_pets')

    click_button('Next')
    expect(page).to have_content('Please identify all dogs or cats')
    fill_in('adopter_adoption_app_attributes_current_pets', with: 'I have a dog named Archer')
    choose('adopter_adoption_app_attributes_current_pets_fixed_false')
    fill_in('adopter_adoption_app_attributes_why_not_fixed', with: 'They are perfect just the way they are')
    choose('adopter_adoption_app_attributes_current_pets_uptodate_true')
    fill_in('adopter_adoption_app_attributes_current_pets_uptodate_why', with: 'They do not like shots')
    fill_in('adopter_adoption_app_attributes_vet_info', with: 'Dr. Kreiger 555-555-5555')

    click_button('Next')
    expect(page).to have_content('Reference')
    fill_in('adopter_references_attributes_0_name', with: 'First Reference')
    find('input#adopter_references_attributes_0_phone').trigger('click')
    sleep(1)  #TODO fix this dirty hack
    send_keys_inputmask('input#adopter_references_attributes_0_phone', '1111111111')
    fill_in('adopter_references_attributes_0_email', with: 'first@reference.org')
    fill_in('adopter_references_attributes_0_relationship', with: 'Friend')
    fill_in('adopter_references_attributes_0_whentocall', with: 'After 1pm')

    fill_in('adopter_references_attributes_1_name', with: 'Second Reference')
    find('input#adopter_references_attributes_1_phone').trigger('click')
    sleep(1)  #TODO fix this dirty hack
    send_keys_inputmask('input#adopter_references_attributes_1_phone', '2222222222')
    fill_in('adopter_references_attributes_1_email', with: 'second@reference.org')
    fill_in('adopter_references_attributes_1_relationship', with: 'Friend')
    fill_in('adopter_references_attributes_1_whentocall', with: 'After 2pm')

    fill_in('adopter_references_attributes_2_name', with: 'Third Reference')
    find('input#adopter_references_attributes_2_phone').trigger('click')
    sleep(1)  #TODO fix this dirty hack
    send_keys_inputmask('input#adopter_references_attributes_2_phone', '3333333333')
    fill_in('adopter_references_attributes_2_email', with: 'third@reference.org')
    fill_in('adopter_references_attributes_2_relationship', with: 'Friend')
    fill_in('adopter_references_attributes_2_whentocall', with: 'After 3pm')

    expect{
      click_button('Submit')
    }.to change {Adopter.count}.by(1)

    expect(page).to have_content 'Success! Your adoption application has been submitted'

    ## Now Login and Verify Contents display correctly

    sign_in(admin)

    visit '/adopters'
    expect(page).to have_content('Adoption Applications')
    click_link('Test Adopter')

    expect(page).to have_content('4 hrs alone')
    expect(page).to have_content('Current Pets not Fixed')
    expect(page).to have_content('Current Pets Up to Date')
    expect(page).to have_content('fake@ophrescue.org')
    expect(page).to have_content('(123) 456-7890')
    expect(page).to have_content('Anytime After 3pm')
    expect(page).to have_content('Miss Watir')
    expect(page).to have_content('Rachel 29, Morgan 24')
    expect(page).to have_content('Test Adopter')
    expect(page).to have_content('642 S Ellwood Ave')
    expect(page).to have_content('Apt 3')
    expect(page).to have_content('Baltimore')
    expect(page).to have_content('MD')
    expect(page).to have_content('21224')
    expect(page).to have_content('Google and Craigslist')

    click_link('Dog Info')
    expect(page).to have_field("adoption_app_ready_to_adopt_dt", with: "2012-12-13")
    expect(page).to have_content('Dog will go to the gym with me')
    expect(page).to have_content('In a crate')
    expect(page).to have_content('Dog will come with us on vacation')
    expect(page).to have_content('Would surrender if dog robbed a bank')
    expect(page).to have_content('We will take the dog to training')
    expect(page).to have_content('I never surrendered my pets')
    expect(page).to have_content('Want to love them and hold them')

    click_link('Pet Vet')
    expect(page).to have_content('I have a dog named Archer')
    expect(page).to have_content('Dr. Kreiger 555-555-5555')
    expect(page).to have_content('They are perfect just the way they are')
    expect(page).to have_content('true')
    expect(page).to have_content('They do not like shots')

    click_link('Rental')
    expect(page).to have_content('Jane LandLord')
    expect(page).to have_content('(570) 443-1234')
    expect(page).to have_content('No dogs over 50 lbs')
    expect(page).to have_content('Rent Goes Up $50 a month')

    click_link('References')
    expect(page).to have_content('First Reference')
    expect(page).to have_content('first@reference.org')
    expect(page).to have_content('(111) 111-1111')
    expect(page).to have_content('After 1pm')

    expect(page).to have_content('Second Reference')
    expect(page).to have_content('second@reference.org')
    expect(page).to have_content('(222) 222-2222')
    expect(page).to have_content('After 2pm')

    expect(page).to have_content('Third Reference')
    expect(page).to have_content('third@reference.org')
    expect(page).to have_content('(333) 333-3333')
    expect(page).to have_content('After 3pm')

  end
end
