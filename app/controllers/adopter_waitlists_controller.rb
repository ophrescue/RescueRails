class AdopterWaitlistsController < ApplicationController
  before_action :edit_my_adopters_user, only: %i(create update destroy)
  before_action :edit_all_adopters_user, only: %i(create update destroy)
  before_action :load_waitlist, only: %i(create)
  before_action :load_adopter, only: %i(create)

  respond_to :html, :json

  def index
    redirect_to :root
  end

  def create
    @adopter_waitlist = AdopterWaitlist.find_or_initialize_by(create_params)

    flash[:success] = 'Adpter added to the waitlist' if @adopter_waitlist.save!

    handle_redirect
  end

  private

  def load_adopter_waitlist
    @adopter_waitlist = AdopterWaitlist.find(params[:id])
  end

  def load_waitlist
    @waitlist = Waitlist.find(adopter_waitlist_params[:waitlist_id])
  end

  def load_adopter
    @adopter = Adopter.find(adopter_waitlist_params[:adopter_id])
  end

  def create_params
    { waitlist: @waitlist, adopter: @adopter}
  end

  def adopter_waitlist_params
    params
      .require(:adopter_waitlist)
      .permit(:waitlist_id,
              :adopter_id,
              :rank)
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
