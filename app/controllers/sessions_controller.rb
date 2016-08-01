class SessionsController < ApplicationController
  def create
    user = User.authenticate(params[:session][:email],
                 params[:session][:password])

    if user.nil?
      flash.now[:error] = "Invalid email/password combination."
      render 'new'
    elsif user.locked?
      flash.now[:error] = "Your account is disabled."
      render 'new'
    else
      sign_in user
      user.update_attribute(:lastlogin, Time.now)
      redirect_to root_path
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
