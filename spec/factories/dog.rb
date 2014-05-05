FactoryGirl.define do
  factory :dog do
    sequence(:tracking_id) { |n| n }
    name { Faker::Name.name }
    status 'adoptable'

    trait :adoptable do
      status 'adoptable'
    end

    trait :completed do
      status 'completed'
    end
  end
end
