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
  def new
    @donation = Donation.new
  end

  def create
    @donation = Donation.new donation_params.merge(email: stripe_params["stripeEmail"],
                                                   card_token: stripe_params["stripeToken"])
    raise "Check for errors" unless @donation.valid?
    @donation.process_payment
    @donation.save
  rescue Stripe::CardError
    flash[:error] = e.message
    render :new
  end

  private

  def stripe_params
    params.permit :stripeEmail, :stripeToken
  end

  def donation_params
    params.require(:donation).permit(:name,
                                     :email,
                                     :amount,
                                     :zip,
                                     :comment,
                                     :card_token)
  end
end
