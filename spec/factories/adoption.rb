FactoryBot.define do
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

  factory :adoption_from_existing, class: Adoption do
    dog_id { Dog.pluck(:id).sample }
    adopter_id { Adopter.pluck(:id).sample }
    relation_type { Adoption::RELATION_TYPE.sample }
  end
end
