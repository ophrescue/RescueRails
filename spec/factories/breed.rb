FactoryBot.define do
  factory :breed do
    name { 
      until(bb = Faker::Dog.breed; !Breed.pluck(:name).include?(bb))
      end
      bb
    }
  end
end
