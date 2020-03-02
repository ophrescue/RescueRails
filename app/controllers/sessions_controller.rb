# frozen_string_literal: true

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
  before_action :prevent_caching

  def new
    # it wasn't an access-denied redirect, so there will not be a redirect after login
    clear_return_to if flash.empty?
  end

  def create
    set_remember_me
    base_create
  end

  # The create from clearance/app/controllers/clearance/session_controller.rb
  def base_create
    @user = authenticate(params)

    sign_in(@user) do |status|
      if status.success?
        redirect_back_or url_after_create
      else
        failed_login
        flash.now.alert = status.failure_message
        render template: "sessions/new", status: :unauthorized
      end
    end
  end

  def destroy
    session[:mgr_view] = false

    super
  end

  private

  def failed_login
    email = params[:session][:email]
    user = User.find_by(email: email)
    return if user.nil?

    user.failed_login_attempts += 1
    user.save
  end

  def set_remember_me
    if params[:remember_me]
      cookies.permanent[:remember_me] = true
    else
      cookies.delete(:remember_me)
    end
  end

  def prevent_caching
    # Fix for Mobile Safari https://blog.alex-miller.co/rails/2017/01/07/rails-authenticity-token-and-mobile-safari.html
    response.headers['Cache-Control'] = 'no-store, no-cache'
  end
end
