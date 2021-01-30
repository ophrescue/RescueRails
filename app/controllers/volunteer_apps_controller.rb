class VolunteerAppsController < ApplicationController
  before_action :require_login, except: %i(new create complete)
  before_action :admin_user, only: %i(destroy)

  def index
    @volunteer_apps = VolunteerApp.order(id: :desc)
  end

  def show
    @title = @volunteer_app.name

  end

  def new
    @volunteer_app = VolunteerApp.new
    @volunteer_app.volunteer_foster_app = VolunteerFosterApp.new
    3.times do
      @volunteer_app.volunteer_references.build
    end
  end

  def create
    @volunteer_app = VolunteerApp.new(volunteer_app_params)
    @volunteer_app.status = 'new'

    if @volunteer_app.save
      flash[:success] = 'Volunteer Application Submitted Successfully'
      render 'complete'
    else
      render 'new'
    end
  end

  def complete
  end

  private

  def volunteer_app_params
    params.require(:volunteer_app).permit(:name,
                                          :email,
                                          :phone,
                                          :address1,
                                          :address2,
                                          :city,
                                          :region,
                                          :postal_code,
                                          :referrer,
                                          :writing_interest,
                                          :events_interest,
                                          :fostering_interest,
                                          :training_interest,
                                          :fundraising_interest,
                                          :transport_bb_interest,
                                          :adoption_team_interest,
                                          :admin_interest,
                                          :about)
  end
end
