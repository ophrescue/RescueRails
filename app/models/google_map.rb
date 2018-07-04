class GoogleMap
  include Rails.application.routes.url_helpers
  attr_accessor :latitude, :longitude
  BASE_URL = "https://maps.google.com/"
  IMG_PATH = "maps/api/staticmap?size=250x100&zoom=12&sensor=false&zoom=16&markers="

  def initialize(event)
    @latitude = event.latitude
    @longitude = event.longitude
  end

  def to_s
    template = <<-TMPL.html_safe
      <a href=#{link_url} class='google_map_link'>
        <img src=#{img_src} />
      </a>
    TMPL
  end

  def img_src
    Rails.env.development? ?
      sample_image_path(:map)+"?#{rand(1000000)}":
      "#{BASE_URL}#{IMG_PATH}#{latitude}%2C#{longitude}"
  end

  def link_url
    "#{BASE_URL}?q=#{latitude}%2C#{longitude}"
  end
end
