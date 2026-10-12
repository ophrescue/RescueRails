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
class PasswordsController < Clearance::PasswordsController
  # Clearance::PasswordsController already skips its own :require_login for
  # these actions, but ApplicationController's sitewide login enforcement
  # uses its own differently-named filters (see the comment there), so they
  # need an explicit skip here too -- otherwise a locked-out user could never
  # reach a password reset, and :enforce_sitewide_unlocked_user would raise
  # on current_user being nil for a signed-out visitor.
  skip_before_action :enforce_sitewide_login, raise: false
  skip_before_action :enforce_sitewide_unlocked_user, raise: false
end
