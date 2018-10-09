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
  before_action :select_bootstrap41
  before_action :find_campaign, only: [:edit, :show, :update]

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
    if @campaign.update_attributes(campaign_params)
      flash[:success] = "Campaign Updated"
      redirect_to campaigns_path
    else
      render 'edit'
    end
  end

  private
    def find_campaign
      @campaign = Campaign.find_by_id(params[:id])
    end

    def campaign_params
      params.require(:campaign)
        .permit(:title,
                :description,
                :goal,
                :photo,
                :photo_file_name,
                :photo_content_type,
                :photo_file_size,
                :photo_updated_at,
                :photo_delete)
      end
end
