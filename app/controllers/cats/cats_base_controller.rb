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

class Cats::CatsBaseController < ApplicationController
  PER_PAGE = 30

  def show
    session[:last_cat_manager_search] ||= cats_manager_index_url
    @title = @cat.name
    @carousel = Carousel.new(@cat)
    @adoptapet = Adoptapet.new(@cat.foster&.region)
    flash.now[:danger] = render_to_string partial: 'cats/unavailable_flash_message' if @cat.unavailable?
  end

  private

  def load_cat
    @cat = Cat.find(params[:id])
  end

  def for_page(page = nil)
    @cats = @cats.paginate(per_page: PER_PAGE, page: page || 1)
  end
end
