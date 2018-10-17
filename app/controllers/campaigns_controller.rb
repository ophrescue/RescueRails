#    Copyright 2018 Operation Paws for Homes
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

class CampaignsController < ApplicationController
  before_action :require_login, except: %i[index show]
  before_action :admin_user, except: %i[index show]
  before_action :select_bootstrap41
  before_action :find_campaign, only: %i[edit show update]

  def index
    @campaigns = Campaign.order(created_at: :desc).paginate(page: params[:page], per_page: 30)
  end

  def new
    @campaign = Campaign.new
  end

  def create
    @campaign = Campaign.new(campaign_params)
    if @campaign.save
      flash[:success] = "New Campaign Added"
      redirect_to campaigns_path
    else
      render 'new'
    end
  end

  def update
    @campaign.primary_photo_delete = params[:campaign][:primary_photo_delete]
    @campaign.left_photo_delete = params[:campaign][:left_photo_delete]
    @campaign.middle_photo_delete = params[:campaign][:middle_photo_delete]
    @campaign.right_photo_delete = params[:campaign][:right_photo_delete]

    if @campaign.update(campaign_params)
      flash[:success] = "Campaign Updated"
      redirect_to campaigns_path
    else
      render 'edit'
    end
  end

  def edit; end

  def show; end

  private

  def find_campaign
    @campaign = Campaign.find_by(id: params[:id])
  end

  def campaign_params
    params.require(:campaign)
      .permit(:title,
              :summary,
              :description,
              :goal,
              :primary_photo,
              :primary_photo_file_name,
              :primary_photo_content_type,
              :primary_photo_file_size,
              :primary_photo_updated_at,
              :primary_photo_delete,
              :left_photo,
              :left_photo_file_name,
              :left_photo_content_type,
              :left_photo_file_size,
              :left_photo_updated_at,
              :left_photo_delete,
              :middle_photo,
              :middle_photo_file_name,
              :middle_photo_content_type,
              :middle_photo_file_size,
              :middle_photo_updated_at,
              :middle_photo_delete,
              :right_photo,
              :right_photo_file_name,
              :right_photo_content_type,
              :right_photo_file_size,
              :right_photo_updated_at,
              :right_photo_delete)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end
