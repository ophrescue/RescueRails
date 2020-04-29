# == Schema Information
#
# Table name: treatments
#
#  id             :bigint           not null, primary key
#  name           :string           not null
#  available_for  :string           not null
#  has_result     :boolean          default(FALSE), not null
#  recommendation :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
FactoryBot.define do
  factory :treatment do
    name { Faker::Alphanumeric.alpha(number: 30) }
    available_for { ['Dog','Cat'].sample }
    has_result { [true, false].sample }
    recommendation { Faker::Lorem.sentence }
  end
end
