require 'rails_helper'

RSpec.describe PostalCodeValidator do
  class PostalCodeTest
    include ActiveModel::Validations
    validates_with PostalCodeValidator

    attr_accessor :country
    attr_accessor :postal_code
  end

  describe '#validate' do
    before :each do
      @postal_code_test = PostalCodeTest.new
    end

    it 'can be blank' do
      expect(@postal_code_test).to be_valid
    end

    it 'requires country if not blank' do
      @postal_code_test.postal_code = "12345"
      expect(@postal_code_test).to_not be_valid
      expect(@postal_code_test).to have_exactly(1).errors_on(:postal_code)
    end

    context 'for US addresses' do
      before :each do
        @postal_code_test.country = 'USA'
      end

      context 'is not valid when' do
        it 'is fewer than 5 digits' do
          @postal_code_test.postal_code = '1234'
          expect(@postal_code_test).to_not be_valid
          expect(@postal_code_test).to have_exactly(1).errors_on(:postal_code)
        end

        it 'is between 5 and 9 digits' do
          @postal_code_test.postal_code = '123456'
          expect(@postal_code_test).to_not be_valid
          expect(@postal_code_test).to have_exactly(1).errors_on(:postal_code)
        end

        it 'is more than 9 digits' do
          @postal_code_test.postal_code = '12345-12345'
          expect(@postal_code_test).to_not be_valid
          expect(@postal_code_test).to have_exactly(1).errors_on(:postal_code)
        end

        it 'is 9 digits without a dash' do
          @postal_code_test.postal_code = '123451234'
          expect(@postal_code_test).to_not be_valid
          expect(@postal_code_test).to have_exactly(1).errors_on(:postal_code)
        end
      end

      context 'is valid when' do
        it 'is 5 digits' do
          @postal_code_test.postal_code = '12345'
          expect(@postal_code_test).to be_valid
        end

        it 'is 5 digits then a dash then 4 digits' do
          @postal_code_test.postal_code = '12345-1234'
          expect(@postal_code_test).to be_valid
        end
      end
    end

    context 'for Candian addresses' do
      before :each do
        @postal_code_test.country = 'CAN'
      end

      context 'is not valid when' do
        it 'it is not a postal code' do
          @postal_code_test.postal_code = 'not-real'
          expect(@postal_code_test).to_not be_valid
          expect(@postal_code_test).to have_exactly(1).errors_on(:postal_code)
        end

        it 'it is an invalid postal code' do
          @postal_code_test.postal_code = 'W0W0W0'
          expect(@postal_code_test).to_not be_valid
          expect(@postal_code_test).to have_exactly(1).errors_on(:postal_code)
        end

        it 'it is 5 characters' do
          @postal_code_test.postal_code = 'K1R2R'
          expect(@postal_code_test).to_not be_valid
          expect(@postal_code_test).to have_exactly(1).errors_on(:postal_code)
        end

        it 'it is 7 characters' do
          @postal_code_test.postal_code = 'K1R2R2R'
          expect(@postal_code_test).to_not be_valid
          expect(@postal_code_test).to have_exactly(1).errors_on(:postal_code)
        end
      end

      context 'is valid when' do
        it 'is 6 valid characters' do
          @postal_code_test.postal_code = 'K1K2K2'
          expect(@postal_code_test).to be_valid
        end
      end
    end
  end
end
