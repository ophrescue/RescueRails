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

  before_action :require_login, except: %i[show update]
  before_action :unlocked_user, except: %i[show update]
  before_action :select_bootstrap41
  before_action :show_user_navbar, except: %i[show update]
  before_action :edit_my_adopters_user, only: %i(index create edit destroy)
  before_action :admin_user, only: :contract_received_at

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
      flash[:success] = "Invoice Generated, please share the invoice with the adopter"
      redirect_to invoice_path(@invoice)
    else
      flash.now[:error] = "Invoice could not be saved"
      render 'new'
    end
  end

  def show
    @invoice = Invoice.friendly.find(params[:id])
  end

  def edit
    @invoice = Invoice.friendly.find(params[:id])
    redirect_to invoice_path(@invoice)
  end

  def destroy
    @invoice = Invoice.friendly.find(params[:id])
    if @invoice.open?
      @invoice.destroy
      flash[:error] = "Invoice deleted"
      redirect_to invoices_path
    else
      flash.now[:error] = "Paid Invoices Cannot Be Deleted"
      render 'show'
    end
  end

  def update
    @invoice = Invoice.friendly.find(params[:id])
    @invoice.card_token =  stripe_params["stripeToken"]
    donation_amt = stripe_params["invoice"]["donation"].to_i

    begin
      @invoice.process_payment(donation_amt)
    rescue Stripe::CardError => e
      flash[:error] = e.message
    else
      flash[:success] = 'Payment Processed Successfully '
      InvoiceMailer.invoice_paid(@invoice.id).deliver_later
    ensure
      render :show
    end
  end

  def record_contract
    @invoice = Invoice.friendly.find(params[:id])
    if @invoice.contract_received_at.nil?
      @invoice.contract_received_at = Time.now

    else
      @invoice.contract_received_at = nil

    end
    if @invoice.save!
      flash[:success] = "Contract status updated, notifications sent"
      contract_notification(@invoice)
      redirect_to invoice_path(@invoice)
    else
      flash.now[:error] = "Invoice could not be saved"
      redirect_to invoice_path(@invoice)
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
                  :id,
                  invoice:
                  [
                    :donation
                  ]
  end

  def load_invoiceable
    resource, id = request.path.split('/')[1, 2]
    @invoiceable = resource.singularize.classify.constantize.find(id)
  end

  def contract_notification(invoice)
    if invoice.contract_received_at
      InvoiceMailer.contract_added(invoice.id).deliver_later
    else
      InvoiceMailer.contract_removed(invoice.id).deliver_later
    end
  end

  def edit_my_adopters_user
    redirect_to(root_path) unless current_user.edit_my_adopters? || current_user.edit_all_adopters?
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

end
