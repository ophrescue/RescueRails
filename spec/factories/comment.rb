FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.sentence }
    user
    for_adopter # default to the :for_adopter trait if none is specified

    trait :for_dog do
      association :commentable, factory: :dog
    end

    trait :for_cat do
      association :commentable, factory: :cat
    end

    trait :for_adopter do
      association :commentable, factory: :adopter
    end
  end
end
