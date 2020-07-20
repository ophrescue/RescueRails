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

class InvoiceMailer < ActionMailer::Base
  default from: "Operation Paws for Homes <adopt@ophrescue.org>",
          return_path: 'adopt@ophrescue.org',
          reply_to: 'adopt@ophrescue.org'

  def invoice_paid(invoice_id)
    @invoice = Invoice.find(invoice_id)
    @notify = []
    @notify.push(@invoice.invoiceable.animal.foster.email) unless @invoice.invoiceable.animal.foster.nil?
    # Sends notification to assigned adoption coordinator
    @notify.push(@invoice.invoiceable.adopter.user.email) unless @invoice.invoiceable.adopter.user.nil?
    @notify.push('adopt@ophrescue.org')
    mail(to: @invoice.invoiceable.adopter.email,
      cc: @notify,
      subject: "Thank you for your Adoption Fee Payment #{@invoice.invoiceable.adopter.name}",
      content_type: 'text/html')
  end


end
