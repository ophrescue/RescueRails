class CountyService
  def self.fetch(zip)
    return zip if Rails.env.test?
    return unless ENV['GOOGLE_MAPS_GEOCODE'].present?

    fetch_from_google(zip)
  end

  def self.fetch_from_google(zip)
    result = Geocoder.search(zip)
    google_result = Geocoder::Result::Google.new(result[0].data)
    google_result.sub_state
  end
end
