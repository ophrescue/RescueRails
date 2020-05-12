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

class Cats::ManagerController < Cats::CatsBaseController
  helper_method :fostering_cat?

  autocomplete :cat_breed, :name, full: true

  before_action :send_unauthenticated_to_public_profile, only: %i[show]
  before_action :require_login
  before_action :unlocked_user
  before_action :active_user
  before_action :admin_user, only: %i[destroy]
  before_action :add_cats_user, only: %i[new create]
  before_action :load_cat, only: %i[show edit update destroy]
  before_action :edit_cat_check, only: %i[edit update]
  before_action :select_bootstrap41
  before_action :show_user_navbar

  def index
    session[:last_cat_manager_search] = request.url
    params[:filter_params] ||= {}
    @cat_filter = CatFilter.new search_params.merge({inhibit_pagination: request.format.xls?})
    @cats, @count, @filter_params = @cat_filter.filter
    respond_to do |format|
      format.html
      format.xls { render_cats_xls }
    end
  end

  def new
    @cat = Cat.new
    @on_cancel_path = cats_manager_index_path
    load_instance_variables
  end

  def edit
    load_instance_variables
    @on_cancel_path = cats_manager_path(@cat)
  end

  def update
    if @cat.update(cat_params)
      flash[:success] = 'Cat updated.'
      redirect_to cats_manager_path(@cat)
    else
      load_instance_variables
      flash.now[:error] = 'form could not be saved, see errors below'
      render 'edit'
    end
  end

  def create
    @cat = Cat.new(cat_params)
    @cat.tracking_id = Cat.next_tracking_id if @cat.tracking_id.blank?

    if @cat.save
      flash[:success] = "New Cat Added"
      redirect_to cats_manager_index_path
    else
      load_instance_variables
      flash.now[:error] = 'form could not be saved, see errors below'
      render 'new'
    end
  end

  def destroy
    @cat.destroy
    flash[:success] = "Cat deleted."
    redirect_to cats_path
  end

  private

  def search_params
    # filter_params is not required as it is not supplied for the default manager view
    params.permit(:page,
                  filter_params: [:sort,
                                  :direction,
                                  :search,
                                  :search_field_index,
                                  is_age: [],
                                  is_status:[],
                                  is_size:[],
                                  has_flags:[]])
  end

  def cat_params
    params.require(:cat)
      .permit(:name, :tracking_id, :primary_breed_id, :primary_breed_name, :secondary_breed_id,
              :secondary_breed_name, :status, :age, :size, :is_altered, :gender, :declawed, :litter_box_trained,
              :coat_length, :is_special_needs,
              :no_dogs, :no_cats, :no_kids, :description, :photos_attributes, :foster_id, :foster_start_date,
              :adoption_date, :is_uptodateonshots, :intake_dt, :available_on_dt, :has_medical_need,
              :is_high_priority, :needs_photos, :has_behavior_problem, :needs_foster, :attachments_attributes,
              :petfinder_ad_url, :adoptapet_ad_url, :craigslist_ad_url, :youtube_video_url, :first_shots,
              :second_shots, :third_shots, :rabies, :felv_fiv_test, :flea_tick_preventative, :dewormer,
              :coccidia_treatment, :microchip, :original_name, :fee, :coordinator_id, :sponsored_by, :shelter_id,
              :medical_summary, :wait_list, :behavior_summary, :medical_review_complete, :dewormer, :toltrazuril, :hidden,
              :home_check_required, :no_urban_setting,
              attachments_attributes: [ :attachment, :description, :updated_by_user_id, :_destroy, :id ],
              photos_attributes: [ :photo, :position, :is_private, :_destroy, :id ])
  end

  def load_instance_variables
    @foster_users = User.where(is_foster: true).order("name")
    @coordinator_users = User.where(edit_all_adopters: true).order("name")
    @shelters = Shelter.order("name")
    @cat_breeds = CatBreed.all
  end

  def edit_cats_user
    redirect_to(root_path) unless current_user.edit_dogs?
  end

  def add_cats_user
    redirect_to(root_path) unless current_user.add_dogs?
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def fostering_cat?
    return false unless signed_in?

    @cat.foster_id == current_user.id
  end

  def edit_cat_check
    redirect_to(root_path) unless fostering_cat? || current_user.edit_dogs?
  end

  def active_user
    redirect_to cats_path unless current_user&.active?
  end

  def send_unauthenticated_to_public_profile
    redirect_to(cat_path(params[:id])) unless signed_in?
  end

  def render_cats_xls
    send_data @cats.to_xls(columns: [:id,
                                     :tracking_id,
                                     :name,
                                     { primary_breed: [:name] },
                                     { secondary_breed: [:name] },
                                     :age,
                                     :size,
                                     :intake_dt,
                                     { foster: %i[name city region] }],
                           headers: ['DMS ID',
                                     'Tracking ID',
                                     'Name',
                                     'Primary Breed',
                                     'Secondary Breed',
                                     'Age',
                                     'Size',
                                     'Intake Date',
                                     'Foster Name',
                                     'Foster City',
                                     'Foster State']),
              filename: 'cat_export.xls'
  end
end
