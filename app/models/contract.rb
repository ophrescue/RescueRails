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

class Contract < ApplicationRecord
  attr_accessible # none
  belongs_to :contractable, polymorphic: true

  def get_details
    return {} if ENV['ESIGNATURES_API_KEY'].blank?
    @_get_details ||= begin
      r = RestClient.get("https://#{ENV['ESIGNATURES_API_KEY']}:@esignatures.io/api/contracts/#{esig_contract_id}")
      JSON.parse(r)["data"]
    end
  end

end
