FactoryBot.define do
  factory :photo do
    photo_file_name { 'test.png' }
    photo_content_type { 'image/png' }
    photo_file_size { 1024 }
    sequence(:position)
  end
end
