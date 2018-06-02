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
# Table name: dogs
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  tracking_id          :integer
#  primary_breed_id     :integer
#  secondary_breed_id   :integer
#  status               :string(255)
#  age                  :string(75)
#  size                 :string(75)
#  is_altered           :boolean
#  gender               :string(6)
#  is_special_needs     :boolean
#  no_dogs              :boolean
#  no_cats              :boolean
#  no_kids              :boolean
#  description          :text
#  foster_id            :integer
#  adoption_date        :date
#  is_uptodateonshots   :boolean          default(TRUE)
#  intake_dt            :date
#  available_on_dt      :date
#  has_medical_need     :boolean          default(FALSE)
#  is_high_priority     :boolean          default(FALSE)
#  needs_photos         :boolean          default(FALSE)
#  has_behavior_problem :boolean          default(FALSE)
#  needs_foster         :boolean          default(FALSE)
#  petfinder_ad_url     :string(255)
#  adoptapet_ad_url     :string(255)
#  craigslist_ad_url    :string(255)
#  youtube_video_url    :string(255)
#  first_shots          :string(255)
#  second_shots         :string(255)
#  third_shots          :string(255)
#  rabies               :string(255)
#  heartworm            :string(255)
#  bordetella           :string(255)
#  microchip            :string(255)
#  original_name        :string(255)
#  fee                  :integer
#  coordinator_id       :integer
#  sponsored_by         :string(255)
#  shelter_id           :integer
#  medical_summary      :text
#

class DogsController < ApplicationController
  helper_method :fostering_dog?

  autocomplete :breed, :name, full: true

  before_action :authenticate, except: %i(index show)
  before_action :admin_user, only: %i(destroy)
  before_action :add_dogs_user, only: %i(new create)
  before_action :load_dog, only: %i(show edit update destroy)
  before_action :edit_dog_check, only: %i(edit update)
  before_action :select_bootstrap41, only: %i(index manager_index show)

  # find a better home for this
  PER_PAGE = 30

  def index
    @dogs = case
            when params[:autocomplete] # it's autocomplete of dog names on the adopters/:id page
              Dog.autocomplete_name(params[:search])
            else # gallery view
              Dog.gallery_view
            end

    for_page(params[:page])

    respond_to do |format|
      format.html { render 'dogs/gallery/index' }
      format.json { render json: @dogs }
    end
  end

  # access permitted if:
  #       user is logged-in
  #       and user is active
  def manager_index
    index unless current_user&.active?
    puts "incoming params #{params}"
    default_manager_view = params.slice("is_age", "is_status", "is_size", "has_flags", "sort", "is_breed", "search", "search_field_index").empty?
    # TODO THIS IS A HACK THAT NEEDS CLEANUP!!
    full_params = ["is_age", "is_status", "is_size", "has_flags"].inject({}){|hash,attr| hash[attr] = (params && params[attr]) || []; hash}
    full_params["sort"] = params["sort"] || "tracking_id"
    full_params["is_breed"] = params["is_breed"] || ""
    full_params["search"] = params["search"] || ""
    full_params["search_field_index"] = params["search_field_index"] || ""
    #default_manager_view = params.slice("is_age", "is_status", "is_size", "has_flags", "sort", "is_breed", "search", "search_field_index").empty?
    full_params["search_field_text"] = params["search_field_index"] && Dog::SEARCH_FIELDS[params["search_field_index"]]
    puts "merged params #{full_params}"
    params = full_params
    @dogs = case
            when default_manager_view
              params["sort"] = 'tracking_id'
              params["direction"] = 'asc'
              Dog.default_manager_view
            else
              DogFilter.filter(params: params)
            end
    @count = @dogs.count

    @filter_params = params.slice("is_age", "is_status", "is_size", "has_flags", "sort", "is_breed", "search", "search_field_index", "search_field_text")

    puts "filter_params #{@filter_params}"

    for_page(params[:page])

    render 'dogs/manager/index'
  end


  def show
    @title = @dog.name
    @carousel = Carousel.new(@dog)
    flash.now[:warning]= render_to_string partial: 'unavailable_flash_message' if @dog.unavailable?
  end

  def new
    @dog = Dog.new
    load_instance_variables
  end

  def edit
    @dog.primary_breed_name = @dog.primary_breed.name unless @dog.primary_breed.nil?
    @dog.secondary_breed_name = @dog.secondary_breed.name unless @dog.secondary_breed.nil?
    load_instance_variables
  end

  def update
    if @dog.update_attributes(dog_params)
      flash[:success] = 'Dog updated.'
      redirect_to @dog
    else
      load_instance_variables
      render 'edit'
    end
  end

  def create
    @dog = Dog.new(dog_params)
    @dog.tracking_id = Dog.next_tracking_id if @dog.tracking_id.blank?

    if @dog.save
      flash[:success] = "New Dog Added"
      redirect_to dogs_path
    else
      load_instance_variables
      render 'new'
    end
  end

  def destroy
    @dog.destroy
    flash[:success] = "Dog deleted."
    redirect_to dogs_path
  end

  private

  def dog_params
    params.require(:dog)
      .permit(:name,
              :tracking_id,
              :primary_breed_id,
              :primary_breed_name,
              :secondary_breed_id,
              :secondary_breed_name,
              :status,
              :age,
              :size,
              :is_altered,
              :gender,
              :is_special_needs,
              :no_dogs,
              :no_cats,
              :no_kids,
              :description,
              :photos_attributes,
              :foster_id,
              :foster_start_date,
              :adoption_date,
              :is_uptodateonshots,
              :intake_dt,
              :available_on_dt,
              :has_medical_need,
              :is_high_priority,
              :needs_photos,
              :has_behavior_problem,
              :needs_foster,
              :attachments_attributes,
              :petfinder_ad_url,
              :adoptapet_ad_url,
              :craigslist_ad_url,
              :youtube_video_url,
              :first_shots,
              :second_shots,
              :third_shots,
              :rabies,
              :vac_4dx,
              :heartworm_preventative,
              :flea_tick_preventative,
              :bordetella,
              :microchip,
              :original_name,
              :fee,
              :coordinator_id,
              :sponsored_by,
              :shelter_id,
              :medical_summary,
              :behavior_summary,
              :medical_review_complete,
              :autocomplete,
              attachments_attributes:
              [
                :attachment,
                :description,
                :updated_by_user_id,
                :_destroy,
                :id
              ],
              photos_attributes:
              [
                :photo,
                :position,
                :is_private,
                :_destroy,
                :id
              ])
  end

  def load_dog
    @dog = Dog.find(params[:id])
  end

  def load_instance_variables
    5.times { @dog.photos.build }
    5.times { @dog.attachments.build }
    @foster_users = User.where(is_foster: true).order("name")
    @coordinator_users = User.where(edit_all_adopters: true).order("name")
    @shelters = Shelter.order("name")
    @breeds = Breed.all
  end

  def edit_dogs_user
    redirect_to(root_path) unless current_user.edit_dogs?
  end

  def add_dogs_user
    redirect_to(root_path) unless current_user.add_dogs?
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def fostering_dog?
    return false unless signed_in?

    @dog.foster_id == current_user.id
  end

  def edit_dog_check
    redirect_to(root_path) unless fostering_dog? || current_user.edit_dogs?
  end

  def for_page(page = nil)
    @dogs = @dogs.paginate(per_page: PER_PAGE, page: page || 1)
  end

end
