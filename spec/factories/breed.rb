FactoryBot.define do
  factory :breed do
    name {
      until(bb = Faker::Creature::Dog.breed; !Breed.pluck(:name).include?(bb))
      end
      bb
    }
  end
end
