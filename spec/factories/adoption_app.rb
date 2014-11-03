FactoryGirl.define do
  factory :adoption_app do
    adopter
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
    current_pets_fixed true
    max_hrs_alone 3
    is_ofage true

    # TODO look into these fields

    # has_yard true
    # has_fence false
    # has_parks true
    # dog_at_night 'In a crate'
    # have_pets true
    # had_pets true
    # prior_pets 'none'
    # vet_name 'Dr Kreiger'
    # vet_phone '1-800-DOG-MD4U'
    # rent_deposit '500'
    # rent_increase '200'
    # plan_training 'go to dog school'
    # has_new_dog_exp true
    # why_adopt 'dogs are cute and stuff'
  end
end
