class AdoptionAppController < ApplicationController

  before_filter :edit_my_adopters_user, :only => [:update]
  before_filter :edit_all_adopters_user, :only => [:update]

  respond_to :html, :json

  def update
    @adopter = AdoptionApp.find(params[:id])
    @adopter.update_attributes(params[:adoption_app])

    respond_with(@adopter) do |format|
      format.html { render }
      format.json { render json: @adopter }
    end
  end

  private

    def edit_my_adopters_user
      #TODO Figure out how to differentiate these
      redirect_to(root_path) unless current_user.edit_my_adopters?
    end

    def edit_all_adopters_user
      #TODO Figure out how to differentiate these
      redirect_to(root_path) unless current_user.edit_all_adopters?
    end
end
