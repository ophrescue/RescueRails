class UsersBadgesController < ApplicationController
  before_action :select_bootstrap41
  before_action :require_login
  before_action :unlocked_user

  def create
    @user = current_user
    @badge = Badge.find(params[:badge_id])
    @user.badges << @badge
    if @user.save
      flash[:success] = 'Badge Added To Profile'
      redirect_to badges_path
    else
      flash[:error] = 'Error Adding Badge to Profile'
      redirect_to badges_path
    end
  end

  def destroy
    @user = current_user
    @badge = @user.badges.find(params[:badge_id])
    @user.badges.delete( @badge )
    flash[:success] = 'Badge Removed From Profile'
    redirect_to badges_path
  end
end
