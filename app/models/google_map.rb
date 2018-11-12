class GoogleMap
  include Rails.application.routes.url_helpers
  attr_accessor :latitude, :longitude
  BASE_URL = "https://maps.google.com/"

  def initialize(event)
    @latitude = event.latitude
    @longitude = event.longitude
  end

  def to_s
    template = <<-TMPL.html_safe
      <a href=#{link_url} target="_blank">
        View Location on Google Maps
      </a>
    TMPL
  end

  def link_url
    "#{BASE_URL}?q=#{latitude}%2C#{longitude}"
  end
end
