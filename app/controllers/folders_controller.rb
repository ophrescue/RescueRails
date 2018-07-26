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

class FoldersController < ApplicationController
  before_action :require_login
  before_action :dl_resource_user
  before_action :admin_user, only: %i[new create edit update destroy]

  def index
    if params[:search].present?
      @folder = FolderSearcher.search(current_user, params: params)
    else
      @folder = Folder.order(:name)
      @folder.each do |a|
        a.attachments.build
      end
    end
  end

  def show
    @folder = Folder.find(params[:id])

    if @folder.locked && !current_user.dl_locked_resources?
      flash[:error] = 'You do not have permission to view this folder'
      return redirect_to action: :index
    end

    @folder.attachments.build
    @title = @folder.name
  end

  def new
    @folder = Folder.new
  end

  def create
    @folder = Folder.new(folder_params)

    if @folder.save
      flash[:success] = 'New Folder Added'
      handle_redirect
    end
  end

  def update
    @folder = Folder.find(params[:id])
    if @folder.update_attributes(folder_params)
      flash[:success] = 'Folder Updated'
      redirect_to @folder
    else
      flash[:error] = 'Upload Error'
      handle_redirect
    end
  end

  def edit
    @folder = Folder.find(params[:id])
    @folder.attachments.build
  end

  def destroy
    Folder.find(params[:id]).destroy
    flash[:success] = 'Folder Deleted'
    handle_redirect
  end

  private

  def folder_params
    params
      .require(:folder)
      .permit(:description,
              :name,
              :locked,
              attachments_attributes: [
                :attachment,
                :description,
                :updated_by_user_id
              ])
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def dl_resource_user
    redirect_to(root_path) unless current_user.dl_resources?
  end
end
