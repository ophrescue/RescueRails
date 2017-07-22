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
    @dogs = Dog.includes(:photos, :foster)
    if @manager
      @dogs = @dogs.includes(:adopters, :comments)
      if text_search? && tracking_id_search?
        @dogs = @dogs.where('tracking_id = :search OR microchip = :search', search: search_term )
      elsif text_search? && !tracking_id_search?
        @dogs = @dogs.where('microchip ILIKE :search OR name ILIKE :search', search: "%#{search_term.strip}%")
      elsif active_status_search?
        @dogs = @dogs.where("status IN (?)", ACTIVE_STATUSES)
      elsif status_search?
        @dogs = @dogs.where(status: @params[:status])
      else
        @dogs = @dogs.filter(filtering_params)
      end
    else
      @dogs = @dogs.includes(:primary_breed, :secondary_breed).where("status IN (?)", PUBLIC_STATUSES)
    end

    with_includes
    with_sorting
    for_page(@params[:page])

    @dogs
  end

  def self.search(params: {}, manager: false)
    new(params: params, manager: manager).search
  end

  private

  def tracking_id_search?
    @params[:search].scan(/\D/).empty? &&
    @params[:search].to_i > 0 &&
    @params[:search].to_i < 2_147_483_647
  end

  def text_search?
    @params[:search].present?
  end

  def search_term
    @params[:search]
  end

  def active_status_search?
    @params[:status] == 'active'
  end

  def status_search?
    @params.key? :status
  end

  def with_includes
    @dogs = @dogs.includes(:photos, :primary_breed)
  end

  def with_sorting
    @dogs = @dogs.order(sort_column + ' ' + sort_direction)
  end

  def for_page(page = nil)
    @dogs = @dogs.paginate(per_page: PER_PAGE, page: page || 1)
  end

  def filtering_params
    @params.slice(:age,
                  :size,
                  :status
                 )
  end

  def sort_column
    Dog.column_names.include?(@params[:sort]) ? @params[:sort] : 'tracking_id'
  end

  def sort_direction
    %w(asc desc).include?(@params[:direction]) ? @params[:direction] : 'asc'
  end
end
