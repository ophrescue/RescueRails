FactoryGirl.define do
  factory :user do
    sequence(:email)   { |n| "test#{n}@test.com" }

    name { Faker::Name.name }
    password { Faker::Internet.password(10) }
    address1 { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    zip { Faker::Address.zip }
    lastverified { Time.now }

    trait :admin do
      admin true
      edit_dogs true
      edit_my_adopters true
      edit_all_adopters true
      edit_events true
      complete_adopters true
      add_dogs true
      ban_adopters true
    end
  end
end
