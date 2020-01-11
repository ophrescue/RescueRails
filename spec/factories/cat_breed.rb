FactoryBot.define do
    factory :cat_breed do
      name {
        until(bb = Faker::Creature::Cat.breed; !CatBreed.pluck(:name).include?(bb))
        end
        bb
      }
    end
  end
