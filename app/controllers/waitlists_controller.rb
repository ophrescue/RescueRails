# Copyright 2017 Operation Paws for Homes
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
# Table name:  waitlists
# id            :integer not null, primary key
# name          :string
# description   :text
# created_at    :datetime
# updated_at    :datetime
#

class WaitlistsController < ApplicationController
  before_action :authenticate
  before_action :edit_my_adopters_user, only: %i(create update destroy)
  before_action :edit_all_adopters_user, only: %i(create update destroy)
  before_action :admin_user, only: [:new, :create, :destroy]

  def index
    @waitlists = Waitlist.order(:id)
  end

  def show
    @waitlist = Waitlist.find(params[:id])
    @title = @waitlist.name
    @adopter_waitlists = @waitlist.adopter_waitlists

    # add adopter
    @adopters = Adopter.all

    # add dog
    @dogs = Dog.where(waitlist_id: nil)
  end

  def new
    @waitlist = Waitlist.new
  end

  def create
    @waitlist = Waitlist.new(waitlist_params)

    if @waitlist.save
      flash[:success] = "Waitlist Added"
      redirect_to waitlists_path
    else
      render 'new'
    end
  end

  def edit
    @waitlist = Waitlist.find(params[:id])
  end

  def update
    @waitlist = Waitlist.find(params[:id])

    if @waitlist.update_attributes(waitlist_params)
      flash[:success] = "Record updated."
      redirect_to waitlists_path
    else
      render 'edit'
    end
  end

  private

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def waitlist_params
    params.require(:waitlist).permit(:name,
                                     :description,
                                     dogs_attributes:
                                     [
                                       :id,
                                       :waitlist_id
                                     ],
                                     adopter_waitlists_attributes:
                                     [
                                       :waitlist_id,
                                       :adopter_id,
                                       :rank
                                     ])
  end
end
