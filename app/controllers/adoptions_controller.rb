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
# Table name: adoptions
#
#  id            :integer          not null, primary key
#  adopter_id    :integer
#  dog_id        :integer
#  relation_type :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class AdoptionsController < ApplicationController
  before_action :edit_my_adopters_user, only: %i(update)
  before_action :edit_all_adopters_user, only: %i(update)
  before_action :load_adopter, only: %i(create)
  before_action :load_adoption, only: %i(show update destroy)
  before_action :load_dog, only: %i(create)

  respond_to :html, :json

  def index
    redirect_to :root
  end

  def create
    @adoption = Adoption.find_or_initialize_by(create_params)
    @adoption.relation_type = 'interested'

    flash[:success] = 'Dogs linked to Application' if @adoption.save!

    handle_redirect
  end

  def update
    @adoption.update(adoption_params)

    respond_with(@adoption) do |format|
      format.html { render }
      format.json { render json: @adopter }
    end
  end

  def destroy
    @adoption.destroy
    flash[:success] = 'Dog removed from Application'
  end

  private

  def load_adoption
    @adoption = Adoption.find(params[:id])
  end

  def load_adopter
    @adopter = Adopter.find(adoption_params[:adopter_id])
  end

  def load_dog
    @dog = Dog.find(adoption_params[:dog_id])
  end

  def create_params
    { dog: @dog, adopter: @adopter }
  end

  def adoption_params
    params
      .require(:adoption)
      .permit(:relation_type,
              :dog_id,
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
