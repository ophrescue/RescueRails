class SampleImagesController < ApplicationController
  def show
    # params[:type] is one of "map", "event_image" or any other type that
    # has an images directory in lib/sample_images/
    path = Rails.root.join('lib', 'sample_images', "#{params[:type]}s", "*")
    sample = Dir.glob(path).sample

    send_file( sample,
      :disposition => 'inline',
      :type => 'image/jpeg',
      :x_sendfile => true )
  end
end
