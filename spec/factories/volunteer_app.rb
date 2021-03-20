FactoryBot.define do
  factory :volunteer_app do
      name { Faker::Name.name }
      email { Faker::Internet.email }
      phone { Faker::PhoneNumber.phone_number }
      address1 { Faker::Address.street_address }
      address2 { Faker::Address.street_address }
      city { Faker::Address.city }
      region { Faker::Address.state_abbr }
      postal_code { Faker::Address.zip_code }
      status { VolunteerApp::STATUSES.sample }
      referrer { Faker::Lorem.sentence(word_count: 3) }
      is_subscribed { [true, false].sample }
      marketing_interest { [true, false].sample }
      events_interest { [true, false].sample }
      fostering_interest { false }
      training_interest { [true, false].sample }
      fundraising_interest { [true, false].sample }
      transport_bb_interest { [true, false].sample }
      adoption_team_interest { [true, false].sample }
      admin_interest { [true, false].sample }
      about { Faker::Lorem.paragraph(sentence_count: 2, supplemental: false, random_sentences_to_add: 4) }

      trait :with_foster_app do
        fostering_interest { true }
        after(:create) do |volunteer_app|
            create(:volunteer_foster_app, volunteer_app: volunteer_app)
        end
      end
  end
end
