class AdoptionAppController < ApplicationController

  before_filter :edit_my_adopters_user, only: [:update]
  before_filter :edit_all_adopters_user, only: [:update]

  respond_to :html, :json

  def update
    @adopter = AdoptionApp.find(params[:id])
    @adopter.update_attributes(adoption_app_params)

    respond_with(@adopter) do |format|
      format.html { render }
      format.json { render json: @adopter }
    end
  end

  private

    def adoption_app_params
      params.require(:adoption_app).permit( :adopter_id,
                                            :spouse_name,
                                            :other_household_names,
                                            :ready_to_adopt_dt,
                                            :house_type,
                                            :dog_exercise,
                                            :dog_stay_when_away,
                                            :dog_vacation,
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
                                            :is_ofage
                                          )
    end

    def edit_my_adopters_user
      #TODO Figure out how to differentiate these
      redirect_to(root_path) unless current_user.edit_my_adopters?
    end

    def edit_all_adopters_user
      #TODO Figure out how to differentiate these
      redirect_to(root_path) unless current_user.edit_all_adopters?
    end
end
