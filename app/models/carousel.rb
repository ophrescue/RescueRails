class Carousel
  attr_accessor :photos

  def initialize(animal)
    @photos = animal.photos.visible
  end

  def to_s
    (photo_collection || no_photo).to_json.html_safe
  end

  def no_photo
    {image: Photo.no_photo_url}
  end

  def photo_collection
    photos.any? && photos.collect(&:to_carousel)
  end

end
