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

class PagesController < ApplicationController
  before_action :authenticate, only: [:status_definitions]
  before_action :select_bootstrap41, only: [:home]

  def status_definitions
    @hide_topbar = true
  end

  def dog_status_definitions
    @hide_topbar = true
  end
end
