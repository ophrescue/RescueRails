class Adoptapet
  attr_accessor :region, :shelter_id

  SHELTERS = {MD: '80736',
              PA: '84558',
              VA: '79954'}

  BASE_URL = "http://www.adoptapet.com/shelter{shelter_id}-dogs.html" 

  def initialize(region)
    @region = region
    @shelter_id = SHELTERS[region&.to_sym]
  end

  def url
    BASE_URL.gsub(/\{shelter_id\}/,shelter_id)
  end

  def to_s
    return "Foster needed for Adoptapet" if no_foster_or_region?
    return "Adoptapet N/A for #{region}" if out_of_area?
    "<a href=\"#{url}\">Adoptapet #{region}</a>".html_safe
  end

  private
  def no_foster_or_region?
    region.nil?
  end

  def out_of_area?
    !SHELTERS.keys.include?(region.to_sym)
  end
end
