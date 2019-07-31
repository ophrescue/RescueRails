FactoryBot.define do
  factory :opportunity do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.sentence }
    user
  end
end
