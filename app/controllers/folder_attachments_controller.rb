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
# Table name: folders
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  locked      :boolean          default(FALSE)
#

class FolderAttachmentsController < ApplicationController
  before_action :authenticate
  before_action :dl_resource_user

  def index
    @attachments = FolderAttachment.accessible_by(current_user)
                                   .matching(params[:search])
                                   .map{|a| a.becomes(Attachment) }
  end

  def update
    respond_to do |request|
      request.json { head 200 }
    end
  end

  private

  def dl_resource_user
    redirect_to(root_path) unless current_user.dl_resources?
  end
end
