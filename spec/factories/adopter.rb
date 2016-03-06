FactoryGirl.define do
  factory :adopter do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.phone_number }
    address1 { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    zip { Faker::Address.zip_code }
    status 'new'

    factory :adopter_with_app do
      after(:create) do |adopter|
        create(:adoption_app, adopter: adopter)
      end
    end

    factory :adopter_with_null_app do
      after(:create) do |adopter|
        create(:adoption_app_null, adopter: adopter)
      end
    end
  end
end
