FactoryGirl.define do
  factory :adoption do
    dog
    adopter

    relation_type 'interested'

    trait :adopted do
      relation_type 'adopted'
    end

    trait :returned do
      relation_type 'returned'
    end
  end
end
