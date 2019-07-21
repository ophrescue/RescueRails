
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

class DashboardsController < ApplicationController
  include ApplicationHelper

  before_action :require_login
  before_action :unlocked_user
  before_action :select_bootstrap41

  def index
    @show_user_topbar = true
    @current_user = current_user
    @bulletins = Bulletin.order(created_at: :desc).limit(5)
    # @upcoming_nearby_events = Event.where(event_date: Time.zone.today..3.weeks.from_now).near(current_user.location, 20).limit(10)
    # @my_dogs = Dog.where(foster: current_user).where(status: Dog::ACTIVE_STATUSES).limit(10)
    # @my_adopters = Adopter.where(user: current_user).limit(10)
  end
end
