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

class AdoptAppMailer < ActionMailer::Base
  default from: "Operation Paws for Homes <adopt@ophrescue.org>",
      return_path: 'adopt@ophrescue.org',
      reply_to: 'adopt@ophrescue.org'

  def adopt_app(adopter_id)
    @destination_email = Rails.env.production? ? "adopt@ophrescue.org" : "admin@ophrescue.org"
    @adopter = Adopter.find(adopter_id)
    mail(to: @destination_email,
       reply_to: "#{@adopter.email}",
       subject: "PLEASE RESPOND #{@adopter.name} for #{@adopter.dog_name} [OPH Adoption]",
       content_type: 'text/html')
  end

  def approved_to_adopt(adopter_id)
    @adopter = Adopter.find(adopter_id)
    mail(to: "#{@adopter.email}",
      subject: "Your OPH Adoption has been Approved",
      content_type: 'text/html')
  end
end
