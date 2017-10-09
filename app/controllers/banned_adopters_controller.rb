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
# Table name: banned_adopters
#
#  id         :integer          not null, primary key
#  name       :string(100)
#  phone      :string(20)
#  email      :string(100)
#  city       :string(100)
#  state      :string(2)
#  comment    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class BannedAdoptersController < ApplicationController
  before_action :authenticate
  before_action :ban_adopters_user, only: [:new, :create, :destroy, :edit, :update, :import]

  def index
    @banned_adopters = BannedAdopter.order(:name)
    respond_to do |format|
      format.html
      format.xls { render_banned_adopters_xls }
    end
  end

  def show
    @banned_adopter = BannedAdopter.find(params[:id])
    @title = @banned_adopter.name
  end

  def new
    @banned_adopter = BannedAdopter.new
  end

  def create
    @banned_adopter = BannedAdopter.new(banned_adopter_params)
    if @banned_adopter.save
      flash[:success] = 'New Banned Adopter Added'
      redirect_to banned_adopters_path
    else
      render 'new'
    end
  end

  def edit
    @banned_adopter = BannedAdopter.find(params[:id])
  end

  def update
    @banned_adopter = BannedAdopter.find_by(id: params[:id])
    if @banned_adopter.update_attributes(banned_adopter_params)
      flash[:success] = 'Record updated.'
      redirect_to banned_adopters_path
    else
      render 'edit'
    end
  end

  private

  def ban_adopters_user
    redirect_to(root_path) unless current_user.ban_adopters?
  end

  def banned_adopter_params
    params
      .require(:banned_adopter)
      .permit(:name,
              :phone,
              :email,
              :city,
              :state,
              :comment)
  end

  def render_banned_adopters_xls
    send_data @banned_adopters.to_xls(
      filename: 'banned_adopters.xls',
      columns: [
        :id,
        :name,
        :phone,
        :email,
        :city,
        :state,
        :comment
      ],
      headers: [
        'id',
        'Name',
        'Phone Number',
        'Email Address',
        'City',
        'State',
        'Comment'
      ]
    )
  end
end
