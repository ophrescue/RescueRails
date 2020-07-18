FactoryBot.define do
    factory :cat_adoption do
      cat
      adopter

      relation_type { 'interested' }

      trait :adopted do
        relation_type { 'adopted' }
      end

      trait :returned do
        relation_type { 'returned' }
      end
    end

    factory :cat_adoption_from_existing, class: Adoption do
      adopter_id { Adopter.pluck(:id).sample }
      cat_id do
        # random selection could (and has) caused duplicate adopter_id, dog_id pairs
        until !Adopter.find(adopter_id).cats.map(&:id).include? (id = Cat.pluck(:id).sample ) do
        end
        id
      end
      relation_type { CatAdoption::RELATION_TYPE.sample }
    end
  end
