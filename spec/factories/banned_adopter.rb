FactoryBot.define do
  factory :banned_adopter do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.cell_phone }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    comment 'BANNED!'
  end
end
