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

class Posts::OpportunitiesController < ApplicationController

    before_action :require_login
    before_action :unlocked_user
    before_action :select_bootstrap41
    before_action :admin_user, only: %i[new create edit update destroy]

    def index
      @opportunities = Opportunity.order(created_at: :desc)
    end

    def new
      @opportunity = Opportunity.new
    end

    def update
      @opportunity = Opportunity.find_by(id: params[:id])
      if @opportunity.update_attributes(opportunity_params)
        flash[:success] = "Opportunity updated."
        redirect_to  opportunity_path
      else
        render 'edit'
      end
    end

    def edit
      @opportunity = Opportunity.find(params[:id])
    end

    def show
      @opportunity = Opportunity.find(params[:id])
    end

    def create
      @opportunity = Opportunity.new(opportunity_params)
      @opportunity.user_id = current_user.id
      if @opportunity.save
        flash[:success] = "New Opportunity added"
        redirect_to opportunities_path
      else
        render 'new'
      end
    end

    def destroy
      @opportunity = Opportunity.find(params[:id])
      @opportunity.destroy
      flash[:notice] = "Opportunity deleted"
      redirect_to opportunities_path
    end


    private

    def admin_user
      flash[:error] = "You aren't allowed to do that."  unless current_user.admin?
      redirect_to(root_path) unless current_user.admin?
    end

    def opportunity_params
      params
        .require(:opportunity)
        .permit(:title,
                :content
               )
    end

  end
