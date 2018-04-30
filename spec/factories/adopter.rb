module AdopterHelpers
  def call_times
    ["mornings", "afternoons", "evenings",
     "not after 9pm",
     "weekends", "any time"]
  end

end

FactoryBot::SyntaxRunner.send(:include, AdopterHelpers)

FactoryBot.define do
  factory :adopter do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.phone_number }
    address1 { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    zip { Faker::Address.zip_code }
    status { Adopter::STATUSES.sample }
    when_to_call { call_times.sample }
    training_email_sent false
    dog_reqs { Faker::Lorem.sentence }
    why_adopt { Faker::Lorem.sentence }
    dog_name { Faker::Dog.name }
    other_phone { Faker::PhoneNumber.phone_number }
    flag { Adopter::FLAGS.sample }
    is_subscribed { [true, false].sample }
    completed_date { Date.today.advance(days: rand(500)) }
    county { Faker::Address.county }

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
