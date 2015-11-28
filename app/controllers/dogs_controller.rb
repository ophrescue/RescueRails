class DogsController < ApplicationController
  helper_method :is_fostering_dog?

  autocomplete :breed, :name, full: true

  before_filter :authenticate, except: %i(index show)
  before_filter :edit_dog_check, only: %i(edit update)
  before_filter :add_dogs_user, only: %i(new create)
  before_filter :admin_user, only: %i(destroy)
  before_filter :load_dog, only: %i(show edit update destroy)

  def index
    is_manager = signed_in? && session[:mgr_view]

    @title = is_manager ? "Dog Manager" : "Our Dogs"
    @dogs = DogSearcher.search(params: params, manager: is_manager)

    respond_to do |format|
      format.html
      format.json { render json: @dogs.map(&:attributes) }
    end
  end

  def show
    @title = @dog.name
  end

  def new
    @dog = Dog.new
    load_instance_variables
    @title = "Add a New Dog"
  end

  def edit
    @dog.primary_breed_name = @dog.primary_breed.name unless @dog.primary_breed.nil?
    @dog.secondary_breed_name = @dog.secondary_breed.name unless @dog.secondary_breed.nil?
    load_instance_variables
    @title = "Edit Dog"
  end

  def update
    if @dog.update_attributes(dog_params)
      flash[:success] = "Dog updated."
      redirect_to @dog
    else
      @title = "Edit Dog"
      load_instance_variables
      render 'edit'
    end
  end

  def create
    @foster_users = User.all
    @dog = Dog.new(dog_params)
    if @dog.tracking_id.blank?
      @dog.tracking_id = Dog.connection.select_value("SELECT nextval('tracking_id_seq')")
    end
    if @dog.save
      flash[:success] = "New Dog Added"
      redirect_to dogs_path
    else
      @title = "Add a New Dog"
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
    if !session[:mgr_view]
      session[:mgr_view] = true
    else
      session[:mgr_view] = false
    end

    redirect_to dogs_path
  end


  private

    def dog_params
      params.require(:dog).permit(  :name,
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
                                    :heartworm,
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
                                    ]

                                  )
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

    def is_fostering_dog?(*args)
      if !signed_in?
        return false
      end

      if args.length == 1
        dog = Dog.find(:arg1)
      else
        if !dog
          dog = Dog.find(params[:id])
        end
        dog.foster_id == current_user.id
      end
    end

    def edit_dog_check
      redirect_to(root_path) unless (is_fostering_dog? || current_user.edit_dogs?)
    end

    def fostering_dog_user
      redirect_to(root_path) unless is_fostering_dog?
    end
end
