include ActionDispatch::TestProcess

FactoryBot.define do
  factory :event do
    title 'A Dog Event'
    location_name 'Westminster'
    address { Faker::Address::street_address }
    event_date { Date.today.advance(days: rand(365)-175) }
    start_time { Faker::Time.between(2.days.ago, Time.zone.now, :afternoon) }
    end_time { Faker::Time.between(2.days.ago, Time.zone.now, :evening) }
    description { Faker::Lorem.paragraphs(4).join("\r\r") }
    location_url { Faker::Internet.url }
    location_phone { Faker::Base.with_locale "en-US" do; "(#{Faker::PhoneNumber.area_code}) #{Faker::PhoneNumber.exchange_code}-#{Faker::PhoneNumber.subscriber_number}"; end }
    latitude {(350000000 + rand(150000000)).to_f/10000000} # 35 to 50 deg N
    longitude {(-800000000 - rand(400000000)).to_f/10000000} # 80 to 120 deg W
    photo { fixture_file_upload(Rails.root.join('lib', 'sample_images', 'event_images', "pic_#{rand(15)}.jpg"), 'image/jpg') }
    photographer_name  { Faker::Name.name }
    photographer_url   { Faker::Internet.url }
    facebook_url       { Faker::Internet.url }

    trait :in_the_future do
      event_date { Date.today.advance(days: rand(365)) }
    end

    trait :in_the_past do
      event_date { Date.today.advance(days: -rand(365)) }
    end
  end
end
