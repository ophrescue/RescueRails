FactoryBot.define do
  factory :user do
    # because the default admin user has sequence#3
    # There's nothing sacred about that value, except everyone probably
    # remembers that it's the default login, and you can't teach an old dog new tricks haha
    sequence(:email, 4) { |n| "test#{n}@test.com" }

    name { Faker::Name.name }
    password { Faker::Internet.password(10) }
    address1 { Faker::Address.street_address }
    city { Faker::Address.city }
    region { Faker::Address.state_abbr }
    postal_code { Faker::Address.zip }
    lastverified { Time.now }
    country { 'USA' }
    active true
    admin false

    trait :inactive_user do
      active false
    end

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

    trait :admin_without_extra_privileges do
      admin true
    end

    trait :with_known_authentication_parameters do
      email "test3@test.com"
      password "foobar99"
      password_confirmation "foobar99"
    end

    factory :foster do
      is_foster true
    end

    factory :adoption_coordinator do
      # NOTE: this is not consistent with the definition of adoption_coordinator in the user model
      # it is consistent with the definition of adoption_coordinator in the context of selecting an adoption_coordinator for a dog in dog_form
      # defined here for writing spec around the dog_form,
      # without understanding the inconsistent usage!
      edit_all_adopters true
    end
  end
end
