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
#  donation_id        :bigint
#  has_donation       :boolean          default(FALSE), not null
#
require 'rails_helper'


describe Invoice do
  describe 'invoice_paid' do

    context 'has a valid factory' do
      it 'is valid' do
      expect(build(:invoice_paid)).to be_valid
      end
    end
  end

  describe 'invoice_unpaid' do

    context 'has a valid factory' do
      it 'is valid' do
        expect(build(:invoice_paid)).to be_valid
      end
    end
  end
end
