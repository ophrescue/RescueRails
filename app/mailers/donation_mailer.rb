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

class DonationMailer < ActionMailer::Base
  default from: "Operation Paws for Homes <donate@ophrescue.org>",
          return_path: 'donate@ophrescue.org',
          reply_to: 'donate@ophrescue.org'

  def donation_receipt(donation_id)
    @donation = Donation.find(donation_id)
    mail(to: @donation.email,
         subject: 'OPH Donation Receipt',
         content_type: 'text/html')
  end

  def donation_notification(donation_id)
    @donation = Donation.find(donation_id)
    mail(to: @donation.notify_email,
         subject: "#{@donation.name} just donated to Operation Paws for Homes",
         content_type: 'text/html')
  end

  def donation_accounting_notification(donation_id)
    @donation = Donation.find(donation_id)
    mail(to: 'accounting@ophrescue.org, donate@ophrescue.org, adopt@ophrescue.org',
         subject: "#{@donation.name} just donated $#{@donation.amount} #{@donation.frequency} to OPH",
         content_type: 'text/html')
  end
end
