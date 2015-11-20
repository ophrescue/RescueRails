FactoryGirl.define do
  factory :adoption_app do
    spouse_name { Faker::Name.name }
    other_household_names 'other household'
    ready_to_adopt_dt '2020-01-01'
    house_type 'rent'
    dog_exercise 'will go to the gym'
    dog_stay_when_away 'In a crate'
    dog_vacation 'dog vacation'
    current_pets 'currently have a bunch of dogs'
    why_not_fixed ''
    current_pets_uptodate true
    current_pets_uptodate_why 'none'
    landlord_name 'Mr. Landlord'
    landlord_phone '443-111-1090'
    rent_dog_restrictions 'no pittbulls'
    surrender_pet_causes 'if it bit me'
    training_explain 'i like training'
    surrendered_pets 'never'
    how_did_you_hear 'google ad'
    pets_branch 'other_pets'
    current_pets_fixed true
    rent_costs '$500 pet deposit'
    vet_info 'Dr. Spaceman Baltimore MD'
    max_hrs_alone 3
    is_ofage true
  end
end
