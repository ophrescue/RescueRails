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
class DonationsController < ApplicationController
  PER_PAGE = 30

  before_action :require_login, except: %i[new create index]
  before_action :unlocked_user, except: %i[new create index]
  before_action :admin_user, only: %i[history show]
  before_action :select_bootstrap41

  def new
    @donation = Donation.new optional_params
  end

  def index
    redirect_to(new_donation_path)
  end

  def history
    @donations = Donation.order(created_at: :desc).paginate(page: params[:page], per_page: format_for_page)
    respond_to do |format|
      format.html
      format.xls { render_donations_xls }
    end
  end

  def show
    redirect_to(root_path)
  end

  def create
    @donation = Donation.new donation_params.merge(card_token: stripe_params["stripeToken"])

    raise "Check for errors" unless @donation.valid?
    if @donation.subscription?
      @donation.create_subscription
    else
      @donation.process_payment
    end

    @donation.save
    DonationMailer.donation_receipt(@donation.id).deliver_later
    DonationMailer.donation_accounting_notification(@donation.id).deliver_later
    if @donation.notify_someone
      DonationMailer.donation_notification(@donation.id).deliver_later
    end
  rescue Stripe::CardError => e
    flash[:error] = e.message
    render :new
  end

  private

  def format_for_page
    return PER_PAGE unless request.format.xls?
    Donation.count
  end

  def admin_user
    redirect_to(new_donation_path) unless current_user.admin?
  end

  def stripe_params
    params.permit :stripeToken, :utf8, :authenticity_token
  end

  def optional_params
    params.permit(:campaign_id,
                  :comment,
                  :frequency,
                  :amount)
  end

  def donation_params
    params.require(:donation).permit(:name,
                                     :email,
                                     :comment,
                                     :amount,
                                     :frequency,
                                     :notify_someone,
                                     :notify_name,
                                     :notify_email,
                                     :notify_message,
                                     :is_memory_honor,
                                     :campaign_id,
                                     :memory_honor_type,
                                     :memory_honor_name,
                                     :more_contact_info,
                                     :phone,
                                     :address1,
                                     :address2,
                                     :city,
                                     :postal_code,
                                     :region)
  end

  def render_donations_xls
    send_data @donations.to_xls(
      filename: 'donations.xls',
      columns: [
        :id,
        :created_at,
        :name,
        :email,
        :amount,
        :comment
      ],
      headers: [
        'ID',
        'Timestamp',
        'Name',
        'Email',
        'Amount',
        'Comment'
      ]
    )
  end
end
