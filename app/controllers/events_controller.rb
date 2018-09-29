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
  before_action :require_login, except: [:index, :show]
  before_action :edit_events_user, except: [:index, :show]
  before_action :select_bootstrap41
  before_action :find_event, only: [:destroy, :edit, :show, :update]

  def index
    @scope =
      case params[:scope]
      when "upcoming", "past" then params[:scope]
      else "upcoming"
      end
    @events = Event.public_send(@scope)
    @title = t(".title.#{@scope}")
  end

  def new
    source_id = params[:source]
    clone = source_id && Event.pluck(:id).include?(source_id.to_i)
    @event = clone ? Event.from_template(source_id.to_i) : Event.new
    @title = clone ? t(".title.clone") : t(".title.new")
  end

  def update
    @event.photo_delete = params[:event][:photo_delete]

    if @event.update_attributes(event_params)
      flash[:success] = "Event updated."
      redirect_to scoped_events_path('upcoming')
    else
      render 'edit'
    end
  end

  def create
    clone_source_id = params["event"].delete("source")&.to_i
    @event = Event.new(event_params)
    if valid_id?(clone_source_id) && params["event"]["photo_delete"] == "0"
      @event.attach_photo_from(clone_source_id, request)
    end
    if @event.save
      flash[:success] = "New event added"
      redirect_to scoped_events_path("upcoming")
    else
      render 'new'
    end
  end

  def destroy
    @event.destroy
    redirect_scope = @event.upcoming? ? "upcoming" : "past"
    flash[:notice] = "Event deleted"
    redirect_to scoped_events_path(redirect_scope)
  end

  private
  def valid_id?(id)
    Event.pluck(:id).include?(id)
  end

  def find_event
    @event = Event.find(params[:id])
  end

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
