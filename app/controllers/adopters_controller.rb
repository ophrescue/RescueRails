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
# Table name: adopters
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  email               :string(255)
#  phone               :string(255)
#  address1            :string(255)
#  address2            :string(255)
#  city                :string(255)
#  state               :string(255)
#  zip                 :string(255)
#  status              :string(255)
#  when_to_call        :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  dog_or_cat          :string
#  dog_reqs            :text
#  why_adopt           :text
#  dog_name            :string(255)
#  other_phone         :string(255)
#  assigned_to_user_id :integer
#  flag                :string(255)
#  is_subscribed       :boolean          default(FALSE)
#  completed_date      :date
#

class AdoptersController < ApplicationController
  before_action :require_login, except: %i(new create check_email)
  before_action :unlocked_user, except: %i(new create check_email)
  before_action :edit_my_adopters_user, only: %i(index show edit update)
  before_action :edit_all_adopters_user, only: %i(index show edit update)
  before_action :admin_user, only: %i(destroy)
  before_action :load_adopter, only: %i(show update)

  respond_to :html, :json

  def index
    session[:last_search] = request.url
    @adopters = AdopterSearcher.search(params: params, user_id: current_user.id)
  end

  def show
    session[:last_search] ||= adopters_url

    @title = @adopter.name
    @adoption_app = @adopter.adoption_app
    @adopter_users = User.where(edit_my_adopters: true).order("name")

    5.times { @adoption_app.attachments.build }
  end

  def new
    @adopter = Adopter.new
    @adopter.adoption_app = AdoptionApp.new
    @adopter.dog_name = params[:dog_name]
    3.times do
      @adopter.references.build
    end
  end

  def create
    @adopter = Adopter.new(adopter_params)
    @adopter.status = 'new'

    if @adopter.adoption_app.ready_to_adopt_dt.blank?
      @adopter.adoption_app.ready_to_adopt_dt = Date.today
    end

    if @adopter.save
      @adopter.adoptions.each do |a|
        a.relation_type = 'interested'
        a.save
      end

      NewAdopterMailer.adopter_created(@adopter.id).deliver_later
      AdoptAppMailer.adopt_app(@adopter.id).deliver_later
      BitePreventionMailer.bite_prevent(@adopter.id).deliver_later(wait: 24.hours)
      flash[:success] = render_to_string partial: 'adopt_success_message'
      redirect_to root_path(adoptapp: "complete")
    else
      render 'new'
    end
  end

  def update
    @title = @adopter.name
    @adoption_app = @adopter.adoption_app
    @adopter_users = User.where(edit_my_adopters: true).order("name")
    if (params[:adopter][:status] == 'completed') && !can_complete_adopters?
      flash[:error] = "You are not allowed to set an application to completed"
      return render :show
    end

    if @adopter.update(adopter_params)
      flash[:success] = "Application Updated"
      redirect_to adopter_url(@adopter)
    else
      render :show
    end

  end

  def check_email
    adopter_exists = Adopter.where(email: params[:adopter][:email]).exists?

    respond_to do |format|
      format.json { render json: !adopter_exists }
    end
  end

  private

  def adopter_params
    params.require(:adopter).permit(:name,
                                    :email,
                                    :secondary_email,
                                    :phone,
                                    :address1,
                                    :address2,
                                    :city,
                                    :state,
                                    :zip,
                                    :status,
                                    :when_to_call,
                                    :dog_or_cat,
                                    :dog_reqs,
                                    :why_adopt,
                                    :dog_name,
                                    :other_phone,
                                    :assigned_to_user_id,
                                    :flag,
                                    :pre_q_abuse,
                                    :pre_q_dog_adjust,
                                    :pre_q_limited_info,
                                    :pre_q_breed_info,
                                    :pre_q_hold,
                                    :pre_q_costs,
                                    adoption_app_attributes:
                                    [
                                      :id,
                                      :adopter_id,
                                      :spouse_name,
                                      :other_household_names,
                                      :ready_to_adopt_dt,
                                      :house_type,
                                      :verify_home_auth,
                                      :dog_exercise,
                                      :dog_stay_when_away,
                                      :dog_vacation,
                                      :prev_pets_type,
                                      :current_pets_type,
                                      :current_pets,
                                      :why_not_fixed,
                                      :current_pets_uptodate,
                                      :current_pets_uptodate_why,
                                      :landlord_name,
                                      :landlord_phone,
                                      :landlord_email,
                                      :rent_dog_restrictions,
                                      :surrender_pet_causes,
                                      :training_explain,
                                      :surrendered_pets,
                                      :how_did_you_hear,
                                      :pets_branch,
                                      :current_pets_fixed,
                                      :rent_costs,
                                      :vet_info,
                                      :max_hrs_alone,
                                      :is_ofage,
                                      :birth_date,
                                      :has_family_under_18,
                                      :shot_dhpp_dhlpp,
                                      :shot_fpv_fhv_fcv,
                                      :shot_rabies,
                                      :shot_bordetella,
                                      :shot_heartworm,
                                      :shot_flea_tick
                                    ],
                                    references_attributes:
                                    [
                                      :id,
                                      :name,
                                      :phone,
                                      :email,
                                      :relationship,
                                      :whentocall
                                    ]
                                   )
  end

  def load_adopter
    @adopter = Adopter.find(params[:id])
  end

  def edit_my_adopters_user
    # TODO Figure out how to differentiate these
    redirect_to(root_path) unless current_user.edit_my_adopters? || current_user.edit_all_adopters?
  end

  def edit_all_adopters_user
    # TODO Figure out how to differentiate these
    redirect_to(root_path) unless current_user.edit_all_adopters?
  end
end
