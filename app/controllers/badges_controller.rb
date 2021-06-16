#    Copyright 2021 Operation Paws for Homes
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

class BadgesController < ApplicationController
  before_action :select_bootstrap41
  before_action :require_login
  before_action :unlocked_user
  before_action :admin_user


  def index
    @badges = Badge.order(:title).paginate(page: params[:page], per_page: 50)
  end

  def show
    @badge = Badge.find(params[:id])
    @title = @badge.title
  end

  def new
    @badge = Badge.new
  end

  def create
    @badge = Badge.new(badge_params)
    if @badge.save
      flash[:success] = "New Badge Created"
      redirect_to badges_path
    else
      flash.now[:error] = "Badge could not be saved"
      render 'new'
    end
  end

  def update
    @badge = Badge.find(params[:id])
    if @badge.update(badge_params)
      flash[:success] = "Badge Updated"
      redirect_to badges_path
    else
      flash.now[:error] = "Badge could not be updated"
      render 'edit'
    end
  end

  def edit
    @badge = Badge.find(params[:id])
  end

  def destroy
    @badge = Badge.find(params[:id])
    if @badge.destroy
      flash[:success] = 'Badge Deleted'
    else
      flash[:error] = 'Unable to Delete Badge'
    end
  end

  private

  def badge_params
    params.require(:badge).permit(:title,
                                  :image,
                                  :image_file_name,
                                  :image_content_type,
                                  :image_file_size,
                                  :image_updated_at,
                                  :image_delete)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end
