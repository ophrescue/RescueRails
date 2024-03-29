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

class CountyService
  def self.fetch(zip)
    return zip if Rails.env.test?
    return unless ENV['AWS_ACCESS_KEY_ID'].present?

    fetch_from_aws(zip)
  end

  def self.fetch_from_aws(zip)
    result = Geocoder.search(zip)
    return if result.empty?

    aws_result = Geocoder::Result::AmazonLocationService.new(result[0])
    aws_result.instance_variable_get(:@place).instance_variable_get(:@place).sub_region
  end
end
