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
class PasswordResetsController < ApplicationController
  def create
    user = User.find_by(email: params[:email].downcase)

    if user
      user.send_password_reset
      flash[:success] = 'Email sent with password reset instructions'
      redirect_to root_url
    else
      flash.now[:error] = 'Unknown Email Address'
      render 'new'
    end
  end

  def edit
    @user = User.find_by!(password_reset_token: params[:id])
  end

  def update
    @user = User.find_by!(password_reset_token: params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, alert: 'Password reset has expired.'
    elsif @user.update_attributes(user_params)
      redirect_to root_url, success: 'Password has been reset!'
    else
      render :edit
    end
  end

  private

  def user_params
    params
      .require(:user)
      .permit(:password,
              :password_confirmation)
  end
end
