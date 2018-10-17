FactoryBot.define do
  factory :campaign do
    title { 'A Fundraising Campaign' }
    goal { Faker::Number.between(500, 10000) }
    summary { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraphs(2).join("\r\r") }
    primary_photo { fixture_file_upload(Rails.root.join('lib', 'sample_images', 'event_images', "pic_#{rand(15)}.jpg"), 'image/jpg') }
    left_photo { fixture_file_upload(Rails.root.join('lib', 'sample_images', 'event_images', "pic_#{rand(15)}.jpg"), 'image/jpg') }
    middle_photo { fixture_file_upload(Rails.root.join('lib', 'sample_images', 'event_images', "pic_#{rand(15)}.jpg"), 'image/jpg') }
    right_photo { fixture_file_upload(Rails.root.join('lib', 'sample_images', 'event_images', "pic_#{rand(15)}.jpg"), 'image/jpg') }
  end
end
