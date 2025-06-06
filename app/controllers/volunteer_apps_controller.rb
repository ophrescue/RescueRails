class VolunteerAppsController < ApplicationController
  include ApplicationHelper

  before_action :select_bootstrap41
  before_action :require_login
  # before_action :require_login, except: %i(new create complete)
  before_action :admin_user, except: %i(new create complete)

  def index
    @volunteer_apps = VolunteerAppSearcher.search(params: params)
  end

  def show
    @volunteer_app = VolunteerApp.find(params[:id])
    @title = "Volunteer App: " + @volunteer_app.name
  end

  def new
    @volunteer_app = VolunteerApp.new
    @volunteer_app.volunteer_foster_app = VolunteerFosterApp.new
    3.times do
      @volunteer_app.volunteer_references.build
    end
  end

  def update
    @volunteer_app = VolunteerApp.find(params[:id])
    if @volunteer_app.update(volunteer_app_params)
      flash[:success] = 'Application Updated'
      redirect_to @volunteer_app
    else
      flash[:error] = 'Error Saving Volunteer Application Update'
      render 'show'
    end
  end

  def create
    @volunteer_app = VolunteerApp.new(volunteer_app_params)
    if !@volunteer_app.fostering_interest
      @volunteer_app.volunteer_foster_app = nil
      @volunteer_app.volunteer_references.destroy_all
    end
    @volunteer_app.status = 'new'

    if @volunteer_app.save
      flash[:success] = 'Volunteer Application Submitted Successfully'
      VolunteerAppMailer.with(volunteer_app: @volunteer_app).notify_applicant.deliver_later
      VolunteerAppMailer.with(volunteer_app: @volunteer_app).notify_oph.deliver_later
      render 'complete'
    else
      render 'new'
    end
  end

  def complete
  end

  private

  def admin_user
    redirect_to(new_volunteer_app_path) unless current_user.admin?
  end

  def volunteer_app_params
    params.require(:volunteer_app).permit(:name,
                                          :email,
                                          :status,
                                          :phone,
                                          :address1,
                                          :address2,
                                          :city,
                                          :region,
                                          :postal_code,
                                          :referrer,
                                          :marketing_interest,
                                          :events_interest,
                                          :fostering_interest,
                                          :training_interest,
                                          :fundraising_interest,
                                          :lost_dog_interest,
                                          :transport_bb_interest,
                                          :adoption_team_interest,
                                          :admin_interest,
                                          :about,
                                          :adult,
                                          volunteer_foster_app_attributes:[
                                            :can_foster_dogs,
                                            :can_foster_cats,
                                            :home_type,
                                            :rental_restrictions,
                                            :rental_landlord_name,
                                            :rental_landlord_info,
                                            :has_pets,
                                            :vet_info,
                                            :current_pets,
                                            :current_pets_spay_neuter,
                                            :about_family,
                                            :breed_pref,
                                            :ready_to_foster_dt,
                                            :max_time_alone,
                                            :dog_fenced_in_yard,
                                            :dog_exercise,
                                            :kept_during_day,
                                            :kept_at_night,
                                            :kept_when_alone,
                                            :foster_experience
                                          ],
                                          volunteer_references_attributes:
                                          [
                                            :id,
                                            :name,
                                            :phone,
                                            :email,
                                            :relationship
                                          ])
  end
end
