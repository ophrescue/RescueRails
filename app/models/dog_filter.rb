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

class DogFilter
  attr_accessor :params, :manager

  include Sortable

  def initialize(params: {}, manager: false)
    @params = params
    @manager = manager
  end

  def filter
    @dogs = Dog.filter(filtering_params)
               .order( "#{sort_column} #{sort_direction}" )
               .includes(:adoptions, :adopters, :comments, :primary_breed, :secondary_breed, :foster)

  end

  def self.filter(params: {}, manager: false)
    new(params: params, manager: manager).filter
  end

  private


  def filtering_params
    params.slice( :is_age,
                  :is_size,
                  :is_status,
                  :is_breed,
                  :cb_high_priority,
                  :cb_medical_need,
                  :cb_medical_review_needed,
                  :cb_special_needs,
                  :cb_behavior_problems,
                  :cb_foster_needed,
                  :cb_spay_neuter_needed,
                  :cb_no_cats,
                  :cb_no_dogs,
                  :cb_no_kids)
  end
end
