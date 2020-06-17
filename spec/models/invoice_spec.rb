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
