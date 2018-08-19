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
#  id         :bigint(8)        not null, primary key
#  name       :string
#  email      :string
#  amount     :integer
#  zip        :string
#  card_token :string
#  comment    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null

class Donation < ApplicationRecord
  def process_payment
    customer = Stripe::Customer.create email: email,
                                       card: card_token

    Stripe::Charge.create customer: customer.id,
                          amount: amount * 100,
                          description: 'Donation',
                          currency: 'usd'
  end
end
