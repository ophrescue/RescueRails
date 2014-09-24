class AdoptionsController < ApplicationController
  before_filter :edit_my_adopters_user, only: [:update]
  before_filter :edit_all_adopters_user, only: [:update]

  respond_to :html, :json

  def index
    redirect_to :root
  end

  def show
    @adoption = Adoption.find(params[:id])
  end

  def create
    current_adoption = Adoption.where(
      adopter_id: params[:adoption][:adopter_id],
      dog_id: params[:adoption][:dog_id]
    )
    @adoption = Adoption.new(params[:adoption])
    @adoption.relation_type = 'interested'
    if current_adoption.present? || @adoption.save
      flash[:success] = 'Dogs linked to Application'
    end
    handle_redirect
  end

  def update
    @adoption = Adoption.find(params[:id])
    @adoption.update_attributes(params[:adoption])

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

  def handle_redirect
    if request.xhr?
      head 200
    else
      redirect_to request.referer
    end
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
