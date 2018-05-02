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
    adopter_id { Adopter.pluck(:id).sample }
    dog_id do
      # random selection could (and has) caused duplicate adopter_id, dog_id pairs
      until !Adopter.find(adopter_id).dogs.map(&:id).include? (id = Dog.pluck(:id).sample ) do
      end
      id
    end
    relation_type { Adoption::RELATION_TYPE.sample }
  end
end
