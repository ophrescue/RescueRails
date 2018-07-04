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

  before_action :admin_user, only: [:index, :show, :destroy]

  def new
    @donation = Donation.new
  end

  def index
    @donations = Donation.order(:id)
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
    @donation.process_payment
    @donation.save
  rescue Stripe::CardError
    flash[:error] = e.message
    render :new
  end

  private

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def stripe_params
    params.permit :stripeToken, :utf8, :authenticity_token
  end

  def donation_params
    params.require(:donation).permit(:name,
                                     :email,
                                     :amount,
                                     :comment,
                                     :card_token)

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
