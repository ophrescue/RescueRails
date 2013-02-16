# Create a valid adoption application

require 'watir-webdriver'

browser = Watir::Browser.new :chrome
browser.goto 'https://rescuerails.dev/adopters/new'

#Page one

browser.checkbox(:name => 'adopter[pre_q_costs]').set
browser.checkbox(:name => 'adopter[pre_q_surrender]').set
browser.checkbox(:name => 'adopter[pre_q_abuse]').set
browser.checkbox(:name => 'adopter[pre_q_limited_info]').set
browser.checkbox(:name => 'adopter[pre_q_breed_info]').set
browser.checkbox(:name => 'adopter[pre_q_reimbursement]').set

browser.button(:name => 'commit').click

sleep(1)

#Page Two

browser.text_field(:id => 'adopter_name').set 'Mark Watir'
browser.text_field(:id => 'adopter_email').set 'm.a.r.k@ophrescue.org'
browser.text_field(:id => 'adopter_address1').set '642 S Ellwood Ave'
browser.text_field(:id => 'adopter_address2').set 'Apt 3'
browser.text_field(:id => 'adopter_city').set 'Baltimore'
browser.text_field(:id => 'adopter_state').set 'MD'
browser.text_field(:id => 'adopter_zip').set '21224'
browser.text_field(:id => 'adopter_phone').set '7178148284'
browser.text_field(:id => 'adopter_other_phone').set '7178148284'
browser.text_field(:id => 'adopter_when_to_call').set 'Anytime After 3pm'
browser.text_field(:id => 'adopter_adoption_app_attributes_spouse_name').set 'Miss Watir'
browser.text_field(:id => 'adopter_adoption_app_attributes_other_household_names').set 'Rachel 29, Morgan 24'
browser.text_field(:id => 'adopter_adoption_app_attributes_how_did_you_hear').set 'Google and Craigslist'
browser.text_field(:id => 'adopter_adoption_app_attributes_ready_to_adopt_dt').set '2012-12-13'
browser.radio(:id => 'adopter_adoption_app_attributes_is_ofage_true').set
browser.radio(:id => 'adopter_adoption_app_attributes_house_type_rent').set

browser.button(:name => 'commit').click

sleep(1)

browser.text_field(:id => 'adopter_adoption_app_attributes_landlord_name').set 'Miss Watir'
browser.text_field(:id => 'adopter_adoption_app_attributes_landlord_phone').set '570123128148888'
browser.text_field(:id => 'adopter_adoption_app_attributes_rent_dog_restrictions').set 'Miss Watir'
browser.text_field(:id => 'adopter_adoption_app_attributes_rent_costs').set 'Miss Watir'

browser.button(:name => 'commit').click

sleep(1)
browser.text_field(:id => 'adopter_dog_name').set 'Miss Watir'
browser.text_field(:id => 'adopter_dog_reqs').set 'Miss Watir'
browser.text_field(:id => 'adopter_why_adopt').set 'Miss Watir'
browser.text_field(:id => 'adopter_adoption_app_attributes_dog_exercise').set 'Miss Watir'
browser.radio(:id => 'adopter_adoption_app_attributes_dog_stay_when_away_in_a_crate').set
browser.select_list(:id => 'adopter_adoption_app_attributes_max_hrs_alone').select '4'
browser.text_field(:id => 'adopter_adoption_app_attributes_dog_vacation').set 'Miss Watir'
browser.text_field(:id => 'adopter_adoption_app_attributes_training_explain').set 'Miss Watir'
browser.text_field(:id => 'adopter_adoption_app_attributes_surrender_pet_causes').set 'Miss Watir'
browser.text_field(:id => 'adopter_adoption_app_attributes_surrendered_pets').set 'Miss Watir'
browser.radio(:id => 'adopter_adoption_app_attributes_pets_branch_other_pets').set

browser.button(:name => 'commit').click

sleep(1)
browser.text_field(:id => 'adopter_adoption_app_attributes_current_pets').set 'Miss Watir'
browser.radio(:id => 'adopter_adoption_app_attributes_current_pets_fixed_false').set
browser.text_field(:id => 'adopter_adoption_app_attributes_why_not_fixed').set 'They are prefect just the way they are'
browser.radio(:id => 'adopter_adoption_app_attributes_current_pets_uptodate_true').set 
browser.text_field(:id => 'adopter_adoption_app_attributes_current_pets_uptodate_why').set 'They do not like shots'
browser.text_field(:id => 'adopter_adoption_app_attributes_vet_info').set 'Dr. Kreiger 555-555-5555'

browser.button(:name => 'commit').click

sleep(1)
browser.text_field(:id => 'adopter_references_attributes_0_name').set 'Miss Watir'
browser.text_field(:id => 'adopter_references_attributes_0_phone').set '555-555-5555'
browser.text_field(:id => 'adopter_references_attributes_0_email').set 'Miss@ophrescue.org'
browser.text_field(:id => 'adopter_references_attributes_0_relationship').set 'Friend'
browser.text_field(:id => 'adopter_references_attributes_0_whentocall').set 'After 5pm'

browser.text_field(:id => 'adopter_references_attributes_1_name').set 'Miss Watir'
browser.text_field(:id => 'adopter_references_attributes_1_phone').set '555-555-5555'
browser.text_field(:id => 'adopter_references_attributes_1_email').set 'Miss@ophrescue.org'
browser.text_field(:id => 'adopter_references_attributes_1_relationship').set 'Friend'
browser.text_field(:id => 'adopter_references_attributes_1_whentocall').set 'After 5pm'

browser.text_field(:id => 'adopter_references_attributes_2_name').set 'Miss Watir'
browser.text_field(:id => 'adopter_references_attributes_2_phone').set '555-555-5555'
browser.text_field(:id => 'adopter_references_attributes_2_email').set 'Miss@ophrescue.org'
browser.text_field(:id => 'adopter_references_attributes_2_relationship').set 'Friend'
browser.text_field(:id => 'adopter_references_attributes_2_whentocall').set 'After 5pm'

browser.button(:name => 'commit').click
