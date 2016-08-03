FactoryGirl.define do
  factory :attachment do
    attachment_file_name { 'test.pdf' }
    attachment_content_type { 'application/pdf' }
    attachment_file_size { 1024 }
  end
end
