require 'rack/test'

FactoryBot.define do
    factory :badge do
      title { Faker::Lorem.sentence }
      image { Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/photo/25-foster-badge.png", 'image/png') }
    end
  end
