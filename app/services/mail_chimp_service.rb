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

class MailChimpService
  attr_reader :client

  def initialize
    klass = Rails.env.test? ? FakeMailChimpClient : MailChimpClient
    @client = klass.new
  end

  def self.user_subscribe(name, email)
    new.client.user_subscribe(name, email)
  end

  def self.user_unsubscribe(email)
    new.client.user_unsubscribe(email)
  end

  def self.adopter_subscribe(email, merge_vars, interests)
    new.client.adopter_subscribe(email, merge_vars, interests)
  end

  def self.adopter_unsubscribe(email)
    new.client.adopter_unsubscribe(email)
  end
end
