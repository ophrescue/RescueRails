FactoryBot.define do
  factory :event do
    title 'A Dog Event'
    location_name 'Westminster'
    address { Faker::Address::street_address }
    event_date { Date.today.advance(days: rand(365)-175) }
    start_time { Faker::Time.between(2.days.ago, Time.zone.now, :afternoon) }
    end_time { Faker::Time.between(2.days.ago, Time.zone.now, :evening) }
    description { Faker::Lorem.sentence }
    location_url { Faker::Internet.url }
    latitude {(350000000 + rand(150000000)).to_f/10000000} # 35 to 50 deg N
    longitude {(-800000000 - rand(400000000)).to_f/10000000} # 80 to 120 deg W

    trait :in_the_future do
      event_date { Date.today.advance(days: rand(365)) }
    end
  end
end
