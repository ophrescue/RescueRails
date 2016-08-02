# == Schema Information
#
# Table name: adoptions
#
#  id            :integer          not null, primary key
#  adopter_id    :integer
#  dog_id        :integer
#  relation_type :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class AdoptionsController < ApplicationController
  before_action :edit_my_adopters_user, only: [:update]
  before_action :edit_all_adopters_user, only: [:update]

  respond_to :html, :json

  def index
    redirect_to :root
  end

  def show
    @adoption = Adoption.find(params[:id])
  end

  def create
    current_adoption = Adoption.where(
      adopter_id: adoption_params[:adopter_id],
      dog_id: adoption_params[:dog_id]
    )
    @adoption = Adoption.new(adoption_params)
    @adoption.relation_type = 'interested'

    if current_adoption.present? || @adoption.save
      flash[:success] = 'Dogs linked to Application'
    end

    handle_redirect
  end

  def update
    @adoption = Adoption.find(params[:id])
    @adoption.update_attributes(adoption_params)

    respond_with(@adoption) do |format|
      format.html { render }
      format.json { render json: @adopter }
    end
  end

  def destroy
    Adoption.find(params[:id]).destroy
    flash[:warning] = 'Dog removed from Application'

    handle_redirect
  end

  private

  def adoption_params
    params.require(:adoption)
      .permit(:relation_type,
              :dog_id,
              :adopter_id)
  end

  def edit_my_adopters_user
    # TODO: Figure out how to differentiate these
    redirect_to(root_path) unless current_user.edit_my_adopters?
  end

  def edit_all_adopters_user
    # TODO: Figure out how to differentiate these
    redirect_to(root_path) unless current_user.edit_all_adopters?
  end
end
