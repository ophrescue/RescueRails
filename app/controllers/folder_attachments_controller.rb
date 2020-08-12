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
  before_action :select_bootstrap41
  before_action :require_login
  before_action :unlocked_user
  before_action :dl_resource_user

  def index
    @attachments = FolderAttachment.accessible_by(current_user)
                                   .matching(params[:search])
                                   .map{|a| a.becomes(Attachment) }
  end

  def update
    @attachment = FolderAttachment.find(params[:id])
    if @attachment.update_attributes(folder_attachment_params)
      render json: @attachment, status: 200
    else
      head 422
    end
  end

  private

  def dl_resource_user
    redirect_to(root_path) unless current_user.dl_resources?
  end

  def folder_attachment_params
    params.require(:attachment).permit(:description)
  end
end
