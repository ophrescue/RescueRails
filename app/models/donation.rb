#    Copyright 2017 Operation Paws for Homes
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
# == Schema Information
#
# Table name: donations
#
#  id                 :bigint(8)        not null, primary key
#  stripe_customer_id :string
#  name               :string
#  email              :string
#  amount             :integer
#  frequency          :string
#  card_token         :string
#  notify_someone     :boolean
#  notify_name        :string
#  notify_email       :string
#  notify_message     :string
#  is_memory_honor    :boolean
#  memory_honor_type  :string
#  memory_honor_name  :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class Donation < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true
  validates :amount, presence: true

  belongs_to :campaign, optional: true

  TSHIRT_SIZE = { "Small" => 'T-Shirt Size: Small',
                  "Medium" => 'T-Shirt Size: Medium',
                  "Large" => 'Tshirt Size: Large',
                  "X-Large" => 'Tshirt Size: X-Large'}.freeze

  MONTHLY_AMOUNTS = [25, 50, 75, 100].freeze

  def create_subscription
    customer = Stripe::Customer.create email: email,
                                       card: card_token

    Stripe::Subscription.create customer: customer,
                                items: [{ plan: ENV['STRIPE_MONTHLY_DONATION_PLAN'],
                                          quantity: amount * 100 }]
  end

  def process_payment
    customer = Stripe::Customer.create email: email,
                                       card: card_token

    Stripe::Charge.create customer: customer.id,
                          amount: amount * 100,
                          description: 'Donation',
                          currency: 'usd'
  end

  def subscription?
    frequency == 'Monthly'
  end
end
