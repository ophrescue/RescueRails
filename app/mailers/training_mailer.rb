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

class TrainingMailer < ActionMailer::Base
  default from: "Operation Paws for Homes <mindy@ophrescue.org>",
          return_path: 'mindy@ophrescue.org',
          reply_to: 'mindy@ophrescue.org'

  def free_training_notice(adopter_id)
    @adopter = Adopter.find(adopter_id)
    mail(to: @adopter.email,
         subject: 'Free Training Session for your new dog!',
         content_type: 'text/html')
  end
end
