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

class AdoptionAppController < ApplicationController
  before_action :edit_my_adopters_user, only: [:update]
  before_action :edit_all_adopters_user, only: [:update]

  respond_to :html, :json

  def update
    @adopter = AdoptionApp.find(params[:id])
    @adopter.update_attributes(adoption_app_params)

    respond_with(@adopter) do |format|
      format.html { handle_redirect }
      format.json { render json: @adopter }
    end
  end

  private

  def adoption_app_params
    params.require(:adoption_app)
      .permit(:adopter_id,
              :spouse_name,
              :other_household_names,
              :ready_to_adopt_dt,
              :house_type,
              :verify_home_auth,
              :building_type,
              :dog_exercise,
              :fenced_yard,
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
              :has_family_under_18,
              :shot_dhpp_dhlpp,
              :shot_fpv_fhv_fcv,
              :shot_rabies,
              :shot_bordetella,
              :shot_heartworm,
              :shot_flea_tick,
              household_ages: [],
              attachments_attributes:
              [
                :attachment,
                :description,
                :updated_by_user_id,
                :_destroy,
                :id
              ])
  end

  def edit_my_adopters_user
    # TODO Figure out how to differentiate these
    redirect_to(root_path) unless current_user.edit_my_adopters?
  end

  def edit_all_adopters_user
    # TODO Figure out how to differentiate these
    redirect_to(root_path) unless current_user.edit_all_adopters?
  end
end
