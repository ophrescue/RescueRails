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

class Cats::GalleryController < Cats::CatsBaseController
  before_action :load_cat, only: %i(show)
  before_action :select_bootstrap41

  def index
    @cats = case
            when params[:autocomplete] # it's autocomplete of dog names on the adopters/:id page
              Cat.autocomplete_name(params[:search])
            else # gallery view
              Cat.gallery_view
            end

    for_page(params[:page])

    respond_to do |format|
      format.html { render 'index' }
      format.json { render json: @cats }
    end
  end
end
