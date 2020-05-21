#    Copyright 2020 Operation Paws for Homes
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

class InvoicesController < ApplicationController

  before_action :require_login, except: %i[show]
  before_action :active_user, except: %i[show]
  before_action :select_bootstrap41
  before_action :show_user_navbar

  def new
    @invoice = Invoice.new
  end

  def create
    @invoice = Invoice.new(invoice_create_params)
  end

  def show
    @invoice = Invoice.where(params[:url_hash])
  end

  def edit
  end

  def update
  end

  def index
  end

  private

  def invoice_create_params
    params.require(:invoice).permit()
  end

end
