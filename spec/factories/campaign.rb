FactoryBot.define do
  factory :campaign do
    title { 'A Fundraising Campaign' }
    goal { Faker::Number.between(from: 500, to: 10000) }
    summary { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraphs(number: 2).join("\r\r") }
    primary_photo { Rack::Test::UploadedFile.new("lib/sample_images/event_images/pic_#{rand(15)}.jpg", 'image/png') }
    left_photo { Rack::Test::UploadedFile.new("lib/sample_images/event_images/pic_#{rand(15)}.jpg", 'image/png') }
    middle_photo { Rack::Test::UploadedFile.new("lib/sample_images/event_images/pic_#{rand(15)}.jpg", 'image/png') }
    right_photo { Rack::Test::UploadedFile.new("lib/sample_images/event_images/pic_#{rand(15)}.jpg", 'image/png') }
  end
end
