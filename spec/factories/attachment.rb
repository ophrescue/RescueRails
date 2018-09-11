FactoryBot.define do
  factory :attachment do
    attachment_file_name { 'test.pdf' }
    attachment_content_type { 'application/pdf' }
    attachment_file_size { 1024 }
    association :updated_by_user, factory: :user #don't use the shorthand method, this syntax is self-describing

    trait :downloadable do
      after(:create) do |attachment|
        test_file = Rails.root.join('spec','fixtures','doc','sample.pdf')
        download_file = Rails.root.join('public','system','test','attachments',"#{attachment.attachment.hash_key}.pdf")
        FileUtils.mkdir_p(download_file.parent)
        FileUtils.cp test_file, download_file
      end
    end
  end
end
