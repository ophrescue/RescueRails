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

# == Schema Information
#
# Table name: cat_adoptions
#
#  id            :integer          not null, primary key
#  adopter_id    :integer
#  cat_id        :integer
#  relation_type :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class CatAdoptionsController < ApplicationController
  before_action :edit_my_adopters_user, only: %i(update)
  before_action :edit_all_adopters_user, only: %i(update)
  before_action :load_adopter, only: %i(create)
  before_action :load_adoption, only: %i(show update destroy)
  before_action :load_cat, only: %i(create)

  respond_to :html, :json

  def index
    redirect_to :root
  end

  def create
    @cat_adoption = CatAdoption.find_or_initialize_by(create_params)
    @cat_adoption.relation_type = 'interested'

    flash[:success] = 'Cats linked to Application' if @cat_adoption.save!

    handle_redirect
  end

  def update
    @cat_adoption.update_attributes(cat_adoption_params)

    respond_with(@cat_adoption) do |format|
      format.html { render }
      format.json { render json: @adopter }
    end
  end

  def destroy
    @cat_adoption.destroy
    flash[:warning] = 'Cat removed from Application'

    handle_redirect
  end

  private

  def load_adoption
    @cat_adoption = CatAdoption.find(params[:id])
  end

  def load_adopter
    @adopter = Adopter.find(cat_adoption_params[:adopter_id])
  end

  def load_cat
    @cat = Cat.find(cat_adoption_params[:cat_id])
  end

  def create_params
    { cat: @cat, adopter: @adopter }
  end

  def cat_adoption_params
    params
      .require(:cat_adoption)
      .permit(:relation_type,
              :cat_id,
              :adopter_id)
  end

  def edit_my_adopters_user
    # TODO: Figure out how to differentiate these
    redirect_to(root_path) unless current_user.edit_my_adopters?
  end

  def edit_all_adopters_user
    # TODO: Figure out how to differentiate these
    redirect_to(root_path) unless current_user.edit_all_adopters?
  end
end
