# == Schema Information
#
# Table name: invoices
#
#  id                 :bigint           not null, primary key
#  invoiceable_id     :integer
#  invoiceable_type   :string
#  slug               :string
#  amount             :integer
#  status             :string
#  user_id            :bigint
#  description        :text
#  stripe_customer_id :string
#  card_token         :string
#  paid_at            :datetime
#  paid_method        :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

include ActionDispatch::TestProcess

FactoryBot.define do
  factory :invoice_unpaid, class: Invoice do
    amount { Faker::Number.number(digits: 3)}
    status {'open'}
    slug { SecureRandom.urlsafe_base64(32) }
    user
    for_dog
    trait :for_dog do
      association :invoiceable, factory: :adoption
    end
  end

  factory :invoice_paid, class: Invoice do
    amount { Faker::Number.number(digits: 3)}
    paid_at { Faker::Date.backward(days: 14) }
    status {'paid'}
    slug { SecureRandom.urlsafe_base64(32) }
    user
    for_cat
    trait :for_cat do
      association :invoiceable, factory: :cat_adoption
    end
  end
end
