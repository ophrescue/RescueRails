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
  protect_from_forgery except: :stripe_webhook
  PER_PAGE = 30

  before_action :require_login, except: %i[show update begin_checkout stripe_webhook thank_you]
  before_action :unlocked_user, except: %i[show update begin_checkout stripe_webhook thank_you]
  before_action :select_bootstrap41
  before_action :show_user_navbar, except: %i[show update begin_checkout stripe_webhook thank_you]
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

  def thank_you
    if params.key?(:'checkout_id')
      @session = Stripe::Checkout::Session.retrieve(params[:checkout_id])
      @customer = Stripe::Customer.retrieve(@session.customer)
      @invoice = Invoice.friendly.find(@session.metadata.oph_invoice_id)
    else
      flash.now[:error] = "Redirected to Homepage"
      redirect_to(root_path)
    end
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

  def begin_checkout
    @invoice = Invoice.friendly.find(params[:id])
    @donation_amt = params["invoice"]["donation"].to_i
    @total_due = (@donation_amt + @invoice.amount) * 100
    @session = Stripe::Checkout::Session.create({ payment_method_types: ['card'],
                                                  customer_email: @invoice.invoiceable.adopter.email,
                                                  line_items: [
                                                    price_data: {
                                                      product: ENV['STRIPE_ONE_TIME_PAYMENT_PRODUCT'],
                                                      unit_amount: @total_due,
                                                      currency: 'usd'
                                                    },
                                                    quantity: 1
                                                  ],
                                                  metadata: {
                                                    oph_invoice_id: @invoice.id,
                                                    donation_amt: @donation_amt
                                                  },
                                                  mode: 'payment',
                                                  success_url: "#{root_url}invoice_thank_you?checkout_id={CHECKOUT_SESSION_ID}",
                                                  cancel_url: invoice_url(@invoice) })

    redirect_to @session.url
  end

  def stripe_webhook
    payload = request.body.read
    endpoint_secret = ENV['STRIPE_INVOICE_ENDPOINT_SECRET']
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
    rescue JSON::ParserError => e
      # Invalid payload
      return head :bad_request
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      return head :bad_request
    end

    case event['type']
    when 'checkout.session.completed'
      checkout_session = event['data']['object']
      if checkout_session.payment_status == 'paid'
        @invoice = Invoice.find(checkout_session.metadata.oph_invoice_id)
        @invoice.pay_invoice(checkout_session)
        InvoiceMailer.invoice_paid(@invoice.id).deliver_later
      end
    end

    head :no_content
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
    else
      flash.now[:error] = "Invoice could not be saved"
    end
    redirect_to invoice_path(@invoice)
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

  def invoice_begin_checkout_params
    params.require(:invoice).permit(:donation)
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
