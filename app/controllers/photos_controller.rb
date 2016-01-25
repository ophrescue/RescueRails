# == Schema Information
#
# Table name: photos
#
#  id                 :integer          not null, primary key
#  dog_id             :integer
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  created_at         :datetime
#  updated_at         :datetime
#  position           :integer
#  is_private         :boolean          default(FALSE)
#

class PhotosController < ApplicationController

  def sort
    params[:photo].each_with_index do |id, index|
        photo = Photo.find(id)
        photo.update_attribute(:position, index + 1)
      end
    render nothing: true
  end

end
