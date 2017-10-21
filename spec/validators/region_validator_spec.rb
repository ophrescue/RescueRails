require 'rails_helper'

RSpec.describe RegionValidator do
  class RegionTest
    include ActiveModel::Validations
    validates_with RegionValidator

    attr_accessor :country
    attr_accessor :region
  end

  describe '#validate' do
    before :each do
      @region_test = RegionTest.new
    end

    it 'requires country to validate' do
      expect(@region_test).to_not be_valid
      expect(@region_test).to have_exactly(1).errors_on(:region)
    end

    context 'in US regions' do
      before :each do
        @region_test.country = 'USA'
      end

      context 'is not valid when' do
        it 'is fewer than 2 characters' do
          @region_test.region = ''
          expect(@region_test).to_not be_valid
          expect(@region_test).to have_exactly(1).errors_on(:region)
        end

        it 'is more than 2 characters' do
          @region_test.region = 'ABC'
          expect(@region_test).to_not be_valid
          expect(@region_test).to have_exactly(1).errors_on(:region)
        end
      end

      context 'is valid when' do
        it 'is specified' do
          # Presently no validation that region is a real state
          @region_test.region = 'AB'
          expect(@region_test).to be_valid
        end
      end
    end

    context 'for Candian regions' do
      before :each do
        @region_test.country = 'CAN'
      end

      context 'is not valid when' do
        it 'is fewer than 2 characters' do
          @region_test.region = ''
          expect(@region_test).to_not be_valid
          expect(@region_test).to have_exactly(1).errors_on(:region)
        end

        it 'is more than 2 characters' do
          @region_test.region = 'ABC'
          expect(@region_test).to_not be_valid
          expect(@region_test).to have_exactly(1).errors_on(:region)
        end

        it 'is not a real province' do
          @region_test.region = 'ZZ'
          expect(@region_test).to_not be_valid
          expect(@region_test).to have_exactly(1).errors_on(:region)
        end
      end

      context 'is valid when' do
        it 'is a real province' do
          @region_test.region = 'AB'
          expect(@region_test).to be_valid
        end
      end
    end
  end
end
