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

module SessionsHelper
  def active_user?
    current_user&.active?
  end

  def is_locked?
    if current_user.locked?
      cookies.delete(:remember_token)
      self.current_user = nil
      redirect_to root, error: "Your Account is Locked"
    end
  end

  def is_admin?
    current_user.admin? unless current_user.nil?
  end

  def can_edit_events?
    current_user.edit_events? unless current_user.nil?
  end

  def can_add_dogs?
    current_user.add_dogs? unless current_user.nil?
  end

  def can_manage_medical_behavior_summaries?
    current_user.medical_behavior_permission? unless current_user.nil?
  end

  def can_edit_dogs?
    current_user.edit_dogs? unless current_user.nil?
  end

  def can_edit_all_adopters?
    current_user.edit_all_adopters unless current_user.nil?
  end

  def can_edit_my_adopters?
    current_user.edit_my_adopters unless current_user.nil?
  end

  def can_complete_adopters?
    current_user.complete_adopters unless current_user.nil?
  end

  def can_ban_adopters?
    current_user.ban_adopters unless current_user.nil?
  end

  def can_dl_resources?
    current_user.dl_resources unless current_user.nil?
  end

  def can_dl_locked_resources?
    current_user.dl_locked_resources unless current_user.nil?
  end

  def current_user?(user)
    user == current_user
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  private

  def store_location
    session[:return_to] = request.fullpath
  end

  def clear_return_to
    session[:return_to] = nil
  end
end
