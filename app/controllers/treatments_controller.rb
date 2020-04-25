#    Copyright 2020 Operation Paws for Homes
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

class TreatmentsController < ApplicationController
  before_action :admin_user
  before_action :select_bootstrap41
  before_action :show_user_navbar

  def index
    @treatments = Treatment.order(:id)
    respond_to do |format|
      format.html
    end
  end

  def show
    @treatment = Treatment.find(params[:id])
    @title = @treatment.name
  end

  def new
    @treatment = Treatment.new
  end

  def create
    @treatment = Treatment.new(treatment_params)
    if @treatment.save
      flash[:success] = "New Treatment Added"
      redirect_to treatments_path
    else
      render 'new'
    end
  end

  def edit
    @treatment = Treatment.find(params[:id])
  end

  def update
    @treatment = Treatment.find(params[:id])
    if @treatment.update(treatment_params)
      flash[:success] = "Record updated."
      redirect_to treatments_path
    else
      render 'edit'
    end
  end

  private

  def treatment_params
    params.require(:treatment).permit(:name,
                                      :available_for,
                                      :has_result,
                                      :recommendation)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end
