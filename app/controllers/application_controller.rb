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

class ApplicationController < ActionController::Base
  include Clearance::Controller

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include SessionsHelper
  include ApplicationHelper

  # The whole app now requires a valid (signed in + unlocked) login on every
  # page -- this site has been replaced by a new system and is staff/login-only
  # going forward.
  #
  # These two before_actions deliberately do NOT reuse the :require_login /
  # :unlocked_user filter names that dozens of controllers already declare
  # locally (many with their own `except:`/`only:` lists for what used to be
  # public pages). ActiveSupport::Callbacks treats a same-named before_action
  # redeclared in a subclass as a full REPLACEMENT of the inherited one --
  # matched only by kind+name+filter, ignoring any only:/except: difference --
  # not as an additional filter (confirmed via
  # `PagesController._process_action_callbacks`). So reusing those names here
  # would have let every one of those local `except:` lists silently reopen
  # the exact pages they used to exempt. Using distinct names means this
  # filter can't be overridden by any of that pre-existing code; those local
  # declarations still run too, but are now redundant leftovers rather than
  # actual exceptions. Sign-in/password-reset must stay reachable without a
  # session already, so both are explicitly skipped in
  # SessionsController/PasswordsController.
  before_action :enforce_sitewide_login
  before_action :enforce_sitewide_unlocked_user

  helper_method :handle_redirect

  def handle_redirect
    if request.xhr?
      head 200
    else
      redirect_to request.referer
    end
  end

  def select_bootstrap41
    @bootstrap41 = true
  end

  def show_user_navbar
    @show_user_topbar = true
  end

  private

  def enforce_sitewide_login
    require_login
  end

  def enforce_sitewide_unlocked_user
    unlocked_user
  end
end
