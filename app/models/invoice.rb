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
#  id                   :bigint           not null, primary key
#  invoiceable_id       :integer
#  invoiceable_type     :string
#  slug                 :string
#  amount               :integer
#  status               :string
#  user_id              :bigint
#  description          :text
#  stripe_customer_id   :string
#  card_token           :string
#  paid_at              :datetime
#  paid_method          :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  donation_id          :bigint
#  has_donation         :boolean          default(FALSE), not null
#  contract_received_at :datetime
#

class Invoice < ApplicationRecord
  audited only: :contract_received_at
  extend FriendlyId
  include ClientValidated

  belongs_to :invoiceable, polymorphic: true
  belongs_to :user
  belongs_to :donation, optional: true

  friendly_id :url_hash, use: :slugged

  STATUSES = ['open', 'paid']

  validates_presence_of :status
  validates_inclusion_of :status, in: STATUSES

  validates_numericality_of :amount, greater_than: 0

  VALIDATION_ERROR_MESSAGES = { amount: :numeric, donation: :numeric }.freeze

  def pay_invoice(checkout_session)
    ActiveRecord::Base.transaction do
      donation_amt = checkout_session.metadata.donation_amt
      if donation_amt.to_i.positive?
        donation = prepare_donation(donation_amt)
        donation.save
        self.has_donation = true
        self.donation_id = donation.id
      end
      self.paid_method = 'Stripe Checkout'
      self.paid_at = Time.zone.now
      self.status = 'paid'
      save
    end
  end

  def prepare_donation(donation_amt)
    donation = Donation.new
    donation.name = invoiceable.adopter.name
    donation.email = invoiceable.adopter.email
    donation.amount = donation_amt
    donation.frequency = 'Once'
    donation.comment = 'Adoption Fee Roundup - Valid'
    donation
  end

  def open?
    status == 'open'
  end

  def paid?
    status == 'paid'
  end
end
