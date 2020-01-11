#    Copyright 2019 Operation Paws for Homes
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

class CatFilter
  attr_accessor :params, :per_page
  include Sortable

  def initialize(params) # params is string with indifferent access
    @params = params[:filter_params] || {}
    # @params[:sort] == @params["sort"]
    # e.g. @params["search_field_text"] = "Tracking ID"
    @params["search_field_text"] = @params["search_field_index"] && Cat::SEARCH_FIELDS.as_options[@params["search_field_index"]]
    # @params["search_field_text"] == @params[:search_field_text]
    @params.reverse_merge!({sort: "tracking_id"}) # maintains indifferent access
    @params[:direction] = (@params[:sort] == "tracking_id") ? "desc" : "asc"
    @params[:page] = params[:page]
    @per_page = params[:inhibit_pagination] ? Cat.count : Cats::CatsBaseController::PER_PAGE
  end

  def filter
    @cats = Cat.search(search_params).merge(Cat.filter(filtering_params)).merge(Cat.has_flags(flag_params))
                .paginate(per_page: per_page, page: page_params)
                .order( "#{sort_column} #{sort_direction}" )
                .includes(:cat_adoptions, :adopters, :comments, :primary_breed, :secondary_breed, :foster)
    [@cats, @cats.length, params]
  end

  private

  def flag_params
    params[:has_flags] || []
  end

  def filtering_params
    params.slice(:is_age, :is_size, :is_status)
  end

  def page_params
    params[:page] || 1
  end

  def search_params
    params.slice(:search, :search_field_index).values.select(&:present?)
  end
end
