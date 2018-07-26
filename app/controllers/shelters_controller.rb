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
# Table name: shelters
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SheltersController < ApplicationController
  before_action :require_login
  before_action :edit_dogs_user

  def index
    @shelters = Shelter.order(:id)
    respond_to do |format|
      format.html
    end
  end

  def show
    @shelter = Shelter.find(params[:id])
    @title = @shelter.name
  end

  def new
    @shelter = Shelter.new
  end

  def create
    @shelter = Shelter.new(shelter_params)
    if @shelter.save
      flash[:success] = "New Source Shelter Added"
      redirect_to shelters_path
    else
      render 'new'
    end
  end

  def edit
    @shelter = Shelter.find(params[:id])
  end

  def update
    @shelter = Shelter.find(params[:id])
    if @shelter.update(shelter_params)
      flash[:success] = "Record updated."
      redirect_to shelters_path
    else
      render 'edit'
    end
  end

  private

  def edit_dogs_user
    redirect_to(root_path) unless current_user.edit_dogs?
  end

  def shelter_params
    params.require(:shelter).permit(:name)
  end
end
