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

  def index
    @title = session[:mgr_view] ? 'Dog Manager' : 'Our Dogs'

    do_manager_view = signed_in? && session[:mgr_view]

    @dogs = DogSearcher.search(params: params, manager: do_manager_view)

    respond_to do |format|
      format.html { render :index }
      format.json { render json: @dogs }
    end
  end

  def show
    @title = @dog.name
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

  def switch_view
    session[:mgr_view] = !session[:mgr_view]

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
end
