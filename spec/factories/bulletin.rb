FactoryBot.define do
    factory :bulletin do
      title { Faker::Lorem.sentence }
      content { Faker::Lorem.sentence }
    end
  end
