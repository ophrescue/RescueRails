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

  PER_PAGE = 30

  before_action :require_login, except: %i[show]
  before_action :unlocked_user, except: %i[show]
  before_action :select_bootstrap41
  before_action :show_user_navbar

  def new
    load_invoiceable
    @invoice = Invoice.new
  end

  def create
    load_invoiceable
    @invoice = @invoiceable.invoices.build(invoice_create_params)
    @invoice.slug = SecureRandom.urlsafe_base64(32)
    @invoice.user_id = current_user.id
    @invoice.status = 'open'
    if @invoice.save
      flash[:success] = "Invoice Generated"
      redirect_to polymorphic_path([@invoiceable.adopter])
    else
      flash.now[:error] = "Invoice could not be saved"
      render 'new'
    end
  end

  def show
    @invoice = Invoice.friendly.find(params[:id])
  end

  def edit
  end

  def update
    @invoice = Invoice.friendly.find(params[:id])
    @invoice.card_token =  stripe_params["stripeToken"]

    begin
      @invoice.process_payment(@invoice.invoiceable.adopter.email)
    rescue Stripe::CardError => e
      flash[:error] = e.message
    else
      @invoice.paid_method = 'Stripe'
      @invoice.paid_at = Time.now
      @invoice.status = 'paid'
      @invoice.save
      flash[:success] = 'Payment Processed Successfully '
    ensure
      render :show
    end
  end

  def index
    @invoices = Invoice.order(created_at: :desc).paginate(page: params[:page], per_page: format_for_page)
  end

  private

  def format_for_page
    return PER_PAGE unless request.format.xls?

    Invoice.count
  end

  def invoice_create_params
    params.require(:invoice).permit(:amount, :description)
  end

  def stripe_params
    params.permit :stripeToken,
                  :utf8,
                  :authenticity_token,
                  :_method,
                  :id
  end

  def load_invoiceable
    resource, id = request.path.split('/')[1, 2]
    @invoiceable = resource.singularize.classify.constantize.find(id)
  end

end
