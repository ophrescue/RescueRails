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
  before_action :edit_my_adopters_user, only: %i(update)
  before_action :edit_all_adopters_user, only: %i(update)
  before_action :load_adopter, only: %i(create)
  before_action :load_adoption, only: %i(show update destroy)
  before_action :load_dog, only: %i(create)

  respond_to :html, :json

  def index
    redirect_to :root
  end

  def create
    @adoption = Adoption.find_or_initialize_by(create_params)
    @adoption.relation_type = 'interested'

    flash[:success] = 'Dogs linked to Application' if @adoption.save!

    handle_redirect
  end

  def update
    @adoption.update_attributes(adoption_params)

    respond_with(@adoption) do |format|
      format.html { render }
      format.json { render json: @adopter }
    end
  end

  def destroy
    @adoption.destroy
    flash[:warning] = 'Dog removed from Application'

    handle_redirect
  end

  private

  def load_adoption
    @adoption = Adoption.find(params[:id])
  end

  def load_adopter
    @adopter = Adopter.find(adoption_params[:adopter_id])
  end

  def load_dog
    @dog = Dog.find(adoption_params[:dog_id])
  end


  def create_params
    { dog: @dog, adopter: @adopter }
  end

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
