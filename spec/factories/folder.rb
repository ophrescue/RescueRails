FactoryGirl.define do
  factory :folder do
    name { Faker::Lorem.word }
    description { Faker::Lorem.sentence }

    trait :unlocked do
      locked FALSE
    end

    trait :locked do
      locked TRUE
    end

  end
end
