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

class SessionsController < Clearance::SessionsController
  def new
    # it wasn't an access-denied redirect, so there will not be a redirect after login
    clear_return_to if flash.empty?
  end

  # def create
  #   user = User.authenticate(params[:session][:email],
  #                params[:session][:password])

  #   if user.nil?
  #     flash.now[:error] = "Invalid email/password combination."
  #     render 'new'
  #   elsif user.locked?
  #     flash.now[:error] = "Your account is disabled."
  #     render 'new'
  #   else
  #     sign_in user
  #     user.update_attribute(:lastlogin, Time.now)
  #     redirect_back_or(root_path)
  #   end
  # end

  def create
    set_remember_me
    super
  end

  def destroy
    session[:mgr_view] = false

    super
  end

  private

  def set_remember_me
    if params[:remember_me]
      cookies.permanent[:remember_me] = true
    else
      cookies.delete(:remember_me)
    end
  end
end
