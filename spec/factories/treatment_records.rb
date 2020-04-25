# == Schema Information
#
# Table name: treatment_records
#
#  id                :bigint           not null, primary key
#  treatment_id      :integer
#  user_id           :bigint
#  treatable_id      :integer
#  treatable_type    :string
#  administered_date :date
#  due_date          :date
#  result            :string
#  comment           :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
FactoryBot.define do
  factory :treatment_record do
    administered_date { [nil, Date.today.advance(days: -rand(365)).to_s].sample }
    due_date { [nil, Date.today.advance(days: -rand(365)).to_s].sample }
    results { Faker::Lorem.sentence }
    comments { Faker::Lorem.paragraph }
  end
end
