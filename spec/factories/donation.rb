FactoryBot.define do
  factory :donation do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    amount { Faker::Number.between(from: 1, to: 5000) }
    frequency { 'One Time' }
  end
end
