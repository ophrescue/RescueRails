FactoryBot.define do
  factory :photo do
    photo_file_name { 'test.jpeg' }
    photo_content_type { 'image/jpeg' }
    photo_file_size { 1024 }
    sequence(:position)
  end
end
