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

class DogSearcher
  attr_accessor :params, :manager

  PER_PAGE = 30

  ACTIVE_STATUSES = [
    'adoptable',
    'adoption pending',
    'on hold',
    'return pending',
    'coming soon'
  ].freeze

  PUBLIC_STATUSES = ['adoptable', 'adoption pending', 'coming soon'].freeze

  def initialize(params: {}, manager: false)
    @params = params
    @manager = manager
  end

  def search
    if @manager # manager view
      @dogs = Dog.includes(:adoptions, :adopters, :comments)
      @dogs = if text_search? && tracking_id_search?
                @dogs.identity_match_tracking_id_or_microchip(search_term) # sort by search term
              elsif text_search? && !tracking_id_search?
                @dogs.pattern_match_microchip_or_name(search_term) # sort by search term
              else
                @dogs.filter(filtering_params)# sort by sort params
                     .order( sort = "#{sort_column} #{sort_direction}" )
              end
    else # gallery view
      @dogs = Dog.includes(:primary_breed, :secondary_breed, :photos)
                 .where(status: PUBLIC_STATUSES)
    end

    with_sorting
    for_page(params[:page])

  end

  def self.search(params: {}, manager: false)
    new(params: params, manager: manager).search
  end

  private

  def tracking_id_search?
    params[:search].scan(/\D/).empty? &&
      params[:search].to_i > 0 &&
      params[:search].to_i < 2_147_483_647
  end

  def text_search?
    params[:search].present?
  end

  def search_term
    params[:search].strip
  end

  def with_sorting
    if text_search? && unspecified_sort?
      @dogs = @dogs.sort_with_search_term_matches_first(search_term)
    else
      @dogs = @dogs.order( sort = "#{sort_column} #{sort_direction}" )
    end
  end

  def unspecified_sort?
    params[:sort].blank?
  end

  def sort_column
    Dog.column_names.include?(params[:sort]) ? params[:sort] : 'tracking_id'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

  def for_page(page = nil)
    @dogs = @dogs.paginate(per_page: PER_PAGE, page: page || 1)
  end

  def filtering_params
    params.slice(:is_age,
                  :is_size,
                  :is_status,
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
