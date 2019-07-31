FactoryBot.define do
  factory :bulletin do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.sentence }
    user
  end
end
