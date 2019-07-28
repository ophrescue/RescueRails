#    Copyright 2019 Operation Paws for Homes
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

class BulletinsController < ApplicationController
  before_action :require_login
  before_action :unlocked_user
  before_action :select_bootstrap41
  before_action :admin_user, only: %i[new create edit update destroy]

  def index
    @bulletins = Bulletin.order(created_at: :desc)
  end

  def new
    @bulletin = Bulletin.new
  end

  def update
    @bulletin = Bulletin.find_by(id: params[:id])
    if @bulletin.update_attributes(bulletin_params)
      flash[:success] = "Bulletin updated."
      redirect_to bulletins_path
    else
      render 'edit'
    end
  end

  def edit
    @bulletin = Bulletin.find(params[:id])
  end

  def show
    @bulletin = Bulletin.find(params[:id])
  end

  def create
    @bulletin = Bulletin.new(bulletin_params)
    @bulletin.user_id = current_user.id
    if @bulletin.save
      flash[:success] = "New Bulletin added"
      redirect_to bulletins_path
    else
      render 'new'
    end
  end

  def destroy
    @bulletin = Bulletin.find_by(id: params[:id])
    @bulletin.destroy
    flash[:notice] = "Bulletin deleted"
    redirect_to bulletins_path
  end

  private

  def admin_user
    flash[:error] = "You aren't allowed to do that."  unless current_user.admin?
    redirect_to(root_path) unless current_user.admin?
  end

  def bulletin_params
    params
      .require(:bulletin)
      .permit(:title,
              :content)
  end
end
