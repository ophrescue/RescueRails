class PhotosController < ApplicationController

  def sort
    params[:photo].each_with_index do |id, index|
        Photo.update_all({position: index+1}, {id: id})
      end
    render nothing: true
  end

end