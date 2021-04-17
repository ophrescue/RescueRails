#    Copyright 2021 Operation Paws for Homes
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

class VolunteerAppMailer < ActionMailer::Base
  default from: 'Operation Paws for Homes <volunteer@ophrescue.org>',
          return_path: 'volunteer@ophrescue.org',
          reply_to: 'volunteer@ophrescue.org'

  def notify_applicant
    @va = params[:volunteer_app]
    mail(to: @va.email, subject: 'Volunteer Application Received!', content_type: 'text/html') do |format|
      format.mjml
    end
  end

  def notify_oph
    @va = params[:volunteer_app]
    @notify = []

    if @va.fostering_interest
      @notify.push('liz@ophrescue.org')
    end
    if (@va.marketing_interest || @va.events_interest || @va.training_interest || @va.fundraising_interest || @va.transport_bb_interest || @va.adoption_team_interest || @va.admin_interest)
      @notify.push('volunteer@ophrescue.org')
      @notify.push('joanne@ophrescue.org')
    end

    mail(to: @notify, subject: "New Volunteer App #{@va.name}", context_type: 'text/html') do |format|
      format.mjml
    end
  end
end
