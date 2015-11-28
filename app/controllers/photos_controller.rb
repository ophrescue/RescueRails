class PhotosController < ApplicationController

  def sort
    params[:photo].each_with_index do |id, index|
        photo = Photo.find(id)
        photo.update_attribute(:position, index) if photo
      end
    render nothing: true
  end

end