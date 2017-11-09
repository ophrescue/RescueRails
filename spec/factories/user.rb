FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@test.com" }

    name { Faker::Name.name }
    password { Faker::Internet.password(10) }
    address1 { Faker::Address.street_address }
    city { Faker::Address.city }
    region { Faker::Address.state_abbr }
    postal_code { Faker::Address.zip }
    lastverified { Time.now }
    country { 'USA' }

    trait :admin do
      admin true
      edit_dogs true
      edit_my_adopters true
      edit_all_adopters true
      edit_events true
      complete_adopters true
      add_dogs true
      ban_adopters true
      dl_locked_resources true
      medical_behavior_permission true
      active true
    end
  end
end
