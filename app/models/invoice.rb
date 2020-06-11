#    Copyright 2020 Operation Paws for Homes
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

class Invoice < ApplicationRecord
  extend FriendlyId
  include ClientValidated

  belongs_to :invoiceable, polymorphic: true
  belongs_to :user

  friendly_id :url_hash, use: :slugged

  STATUSES = ['open', 'paid']

  validates_presence_of :status
  validates_inclusion_of :status, in: STATUSES

  VALIDATION_ERROR_MESSAGES = {content: :blank}

  def process_payment(email)
    customer = Stripe::Customer.create email: email,
                                       card: card_token

    Stripe::Charge.create customer: customer.id,
                          amount: amount * 100,
                          description: 'Adoption Fee',
                          currency: 'usd'
  end

  def open?
    return true if self.status == 'open'
  end

  def paid?
    return true if self.status == 'paid'
  end

end
