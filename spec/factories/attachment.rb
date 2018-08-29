FactoryBot.define do
  factory :attachment do
    attachment_file_name { 'test.pdf' }
    attachment_content_type { 'application/pdf' }
    attachment_file_size { 1024 }
    association :updated_by_user, factory: :user #don't use the shorthand method, this syntax is self-describing
  end
end
