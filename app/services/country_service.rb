require 'countries'

class CountryService
  SUPPORTED = ISO3166.configuration.locales.map { |locale| ISO3166::Country[locale] }

  def self.supported_country?(country)
    SUPPORTED.include?(country)
  end

  def self.supported_country_names
    SUPPORTED.map(&:name)
  end
end
