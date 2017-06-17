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
# Table name: events
#
#  id                 :integer          not null, primary key
#  title              :string(255)
#  location_name      :string(255)
#  address            :string(255)
#  description        :text
#  created_by_user    :integer
#  created_at         :datetime
#  updated_at         :datetime
#  latitude           :float
#  longitude          :float
#  event_date         :date
#  start_time         :time
#  end_time           :time
#  location_url       :string(255)
#  location_phone     :string(255)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  photographer_name  :string(255)
#  photographer_url   :string(255)
#  facebook_url       :string(255)
#

class EventsController < ApplicationController
  before_action :authenticate, except: [:index, :show, :past]
  before_action :edit_events_user, except: [:index, :show, :past]

  def index
    @events =
      Event
        .where("event_date >= ?", Date.today)
        .limit(30)
        .order('event_date ASC')
  end

  def past
    @events =
      Event
        .where("event_date < ?", Date.today)
        .limit(30)
        .order('event_date DESC')
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    @event.photo_delete = params[:event][:photo_delete]

    if @event.update_attributes(event_params)
      flash[:success] = "Event updated."
      redirect_to events_path
    else
      render 'edit'
    end
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      flash[:success] = "New Event Added"
      redirect_to events_path
    else
      render 'new'
    end
  end

  def destroy
    Event.find(params[:id]).destroy
    flash[:danger] = "Event Deleted"
    redirect_to events_path
  end

  private

  def edit_events_user
    redirect_to(root_path) unless current_user.edit_events?
  end

  def event_params
    params.require(:event)
      .permit(:title,
              :event_date,
              :start_time,
              :end_time,
              :location_name,
              :location_url,
              :photographer_name,
              :photographer_url,
              :location_phone,
              :address,
              :description,
              :latitude,
              :longitude,
              :photo,
              :photo_file_name,
              :photo_content_type,
              :photo_file_size,
              :photo_updated_at,
              :photo_delete,
              :facebook_url)
  end
end
