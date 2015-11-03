FactoryGirl.define do
  factory :photo do
    attachment_file_name { 'test.png' }
    attachment_content_type { 'image/png' }
    attachment_file_size { 1024 }
  end
end