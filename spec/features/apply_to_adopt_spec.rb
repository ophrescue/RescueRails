require 'rails_helper'

feature 'Apply for Adoption' do
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

    fill_in('adopter_name', :with => 'Test Adopter')
    fill_in('adopter_email', :with => 'fake@ophrescue.org')
    fill_in('adopter_address1', :with => '642 S Ellwood Ave')
    fill_in('adopter_address2', :with => 'Apt 3')
    fill_in('adopter_city', :with => 'Baltimore')
    fill_in('adopter_state', :with => 'MD')
    fill_in('adopter_zip', :with => '21224')

    send_keys_inputmask('input#adopter_phone', '1234567890')
    send_keys_inputmask('input#adopter_other_phone', '0987654321')

    fill_in('adopter_when_to_call', :with => 'Anytime After 3pm')
    fill_in('adopter_adoption_app_attributes_spouse_name', :with => 'Miss Watir')
    fill_in('adopter_adoption_app_attributes_other_household_names', :with => 'Rachel 29, Morgan 24')
    fill_in('adopter_adoption_app_attributes_how_did_you_hear', :with => 'Google and Craigslist')
    fill_in('adopter_adoption_app_attributes_ready_to_adopt_dt', :with => '2012-12-13')
    choose('adopter_adoption_app_attributes_is_ofage_true')
    choose('adopter_adoption_app_attributes_house_type_rent')

    click_button('Next')

    fill_in('adopter_adoption_app_attributes_landlord_name', :with => 'Jane LandLord')
    send_keys_inputmask('input#adopter_adoption_app_attributes_landlord_phone', '5704431234')
    fill_in('adopter_adoption_app_attributes_rent_dog_restrictions', :with => 'No dogs over 50 lbs')
    fill_in('adopter_adoption_app_attributes_rent_costs', :with => 'Rent Goes Up $50 a month')

    click_button('Next')

    fill_in('adopter_dog_name', :with => 'Rex and Precious')
    fill_in('adopter_dog_reqs', :with => 'Dog Under 50lbs')
    fill_in('adopter_why_adopt', :with => 'Want to love them and hold them')
    fill_in('adopter_adoption_app_attributes_dog_exercise', :with => 'Dog will go to the gym with me')
    choose('adopter_adoption_app_attributes_dog_stay_when_away_in_a_crate')
    select('4', :from => 'adopter_adoption_app_attributes_max_hrs_alone')
    fill_in('adopter_adoption_app_attributes_dog_vacation', :with => 'Dog will come with us on vacation')
    fill_in('adopter_adoption_app_attributes_training_explain', :with => 'We will take the dog to training')
    fill_in('adopter_adoption_app_attributes_surrender_pet_causes', :with => 'Would surrender if dog robbed a bank')
    fill_in('adopter_adoption_app_attributes_surrendered_pets', :with => 'I never surrendered my pets')
    choose('adopter_adoption_app_attributes_pets_branch_other_pets')

    click_button('Next')

    fill_in('adopter_adoption_app_attributes_current_pets', :with => 'I have a dog named Phily')
    choose('adopter_adoption_app_attributes_current_pets_fixed_false')
    fill_in('adopter_adoption_app_attributes_why_not_fixed', :with => 'They are prefect just the way they are')
    choose('adopter_adoption_app_attributes_current_pets_uptodate_true')
    fill_in('adopter_adoption_app_attributes_current_pets_uptodate_why', :with => 'They do not like shots')
    fill_in('adopter_adoption_app_attributes_vet_info', :with => 'Dr. Kreiger 555-555-5555')

    click_button('Next')

    fill_in('adopter_references_attributes_0_name', :with => 'Miss Watir')
    send_keys_inputmask('input#adopter_references_attributes_0_phone', '1111111111')
    fill_in('adopter_references_attributes_0_email', :with => 'Miss@ophrescue.org')
    fill_in('adopter_references_attributes_0_relationship', :with => 'Friend')
    fill_in('adopter_references_attributes_0_whentocall', :with => 'After 5pm')

    fill_in('adopter_references_attributes_1_name', :with => 'Miss Watir')
    send_keys_inputmask('input#adopter_references_attributes_1_phone','2222222222')
    fill_in('adopter_references_attributes_1_email', :with => 'Miss@ophrescue.org')
    fill_in('adopter_references_attributes_1_relationship', :with => 'Friend')
    fill_in('adopter_references_attributes_1_whentocall', :with => 'After 5pm')

    fill_in('adopter_references_attributes_2_name', :with => 'Miss Watir')
    send_keys_inputmask('input#adopter_references_attributes_2_phone','3333333333')
    fill_in('adopter_references_attributes_2_email', :with => 'Miss@ophrescue.org')
    fill_in('adopter_references_attributes_2_relationship', :with => 'Friend')
    fill_in('adopter_references_attributes_2_whentocall', :with => 'After 5pm')

    click_button('Submit')

    expect(page).to have_content 'Success! Your adoption application has been submitted'

  end
end
