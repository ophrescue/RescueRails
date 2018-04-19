FactoryBot.define do
  factory :reference do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.phone_number }
    relationship 'Your Mom'
    whentocall 'midnight'

    adopter
  end
end
