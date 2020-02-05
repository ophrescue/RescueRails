FactoryBot.define do
  factory :adoption_app do
    spouse_name { Faker::Name.name }
    other_household_names { 'other household' }
    ready_to_adopt_dt { Faker::Date.between(from: 2.days.ago, to: Time.zone.today) }
    house_type { 'rent' }
    dog_exercise { 'will go to the gym' }
    dog_stay_when_away { 'In a crate' }
    dog_vacation { 'dog vacation' }
    current_pets { 'currently have a bunch of dogs' }
    why_not_fixed { '' }
    current_pets_uptodate { true }
    current_pets_uptodate_why { 'none' }
    landlord_name { 'Mr. Landlord' }
    landlord_phone { '443-111-1090' }
    rent_dog_restrictions { 'no pittbulls' }
    surrender_pet_causes { 'if it bit me' }
    training_explain { 'i like training' }
    surrendered_pets { 'never' }
    how_did_you_hear { 'google ad' }
    pets_branch { 'other_pets' }
    current_pets_fixed { true }
    rent_costs { '$500 pet deposit' }
    vet_info { 'Dr. Spaceman Baltimore MD' }
    max_hrs_alone { 3 }
    is_ofage { true }
    birth_date { Faker::Date.between(20.years.ago, Time.zone.today) }
    has_family_under_18 { true }

    factory :adoption_app_null do
      spouse_name { '' }
      other_household_names { nil }
      ready_to_adopt_dt { '2019-08-21' }
      house_type { 'own' }
      dog_exercise { nil }
      dog_stay_when_away { 'here' }
      dog_vacation { nil }
      current_pets { nil }
      why_not_fixed { nil }
      current_pets_uptodate { nil }
      current_pets_uptodate_why { nil }
      landlord_name { nil }
      landlord_phone { nil }
      rent_dog_restrictions { nil }
      surrender_pet_causes { nil }
      training_explain { nil }
      surrendered_pets { nil }
      how_did_you_hear { '' }
      pets_branch { nil }
      current_pets_fixed { true }
      rent_costs { nil }
      vet_info { nil }
      max_hrs_alone { nil }
      is_ofage { true }
      birth_date { 20.years.ago.to_date }
      has_family_under_18 { true }
    end
  end
end
