FactoryBot.define do
  factory :folder do
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }

    trait :unlocked do
      locked { false }
    end

    trait :locked do
      locked { true }
    end
  end
end
