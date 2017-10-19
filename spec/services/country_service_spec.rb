require 'rails_helper'

RSpec.describe CountryService do
  describe '.supported_country?' do
    it 'supports United States' do
      usa = ISO3166::Country.new('US')
      expect(CountryService.supported_country?(usa)).to be true
    end

    it 'supports Canada' do
      canada = ISO3166::Country.new('CA')
      expect(CountryService.supported_country?(canada)).to be true
    end

    it 'does not support other countries' do
      albania = ISO3166::Country.new('AL')
      expect(CountryService.supported_country?(albania)).to be false
    end
  end

  describe '.supported_country_names' do
    it 'lists the names' do
      expect(CountryService.supported_country_names.size).to be CountryService::SUPPORTED.size
    end
  end
end
