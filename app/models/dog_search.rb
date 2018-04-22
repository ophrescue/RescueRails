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

class DogSearch
  include Sortable
  attr_accessor :params, :manager

  def initialize(params: {}, manager: false)
    @params = params
    @manager = manager
  end

  def search
    if @manager # manager view
      @dogs = if tracking_id_search?
                Dog.identity_match_tracking_id_or_microchip(search_term)
              else
                Dog.pattern_match_microchip_or_name(search_term)
              end
      @dogs = @dogs.includes(:adoptions, :adopters, :comments)

      with_sorting
    end

  end

  def self.search(params: {}, manager: false)
    new(params: params, manager: manager).search
  end

  private

  def tracking_id_search?
    !params[:search].nil? &&
      params[:search].scan(/\D/).empty? &&
      params[:search].to_i > 0 &&
      params[:search].to_i < 2_147_483_647
  end

  def search_term
    params[:search].to_s.strip
  end

end
