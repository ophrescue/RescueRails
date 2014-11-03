FactoryGirl.define do
  factory :event do
    title 'A Dog Event'
    location_name 'Westminster'
    address { Faker::Address::street_address }
    event_date { Date.today }
    start_time { Faker::Time.between(2.days.ago, Time.now, :afternoon) }
    end_time { Faker::Time.between(2.days.ago, Time.now, :evening) }
    description { Faker::Lorem.sentence }
    location_url { Faker::Internet.url }
  end
end
