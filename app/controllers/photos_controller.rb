#    Copyright 2017 Operation Paws for Homes
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

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
  before_action :require_login

  def sort
    params[:photo].each_with_index do |id, index|
      photo = Photo.find(id)
      photo.update_attribute(:position, index + 1)
    end

    head :ok
  end
end
