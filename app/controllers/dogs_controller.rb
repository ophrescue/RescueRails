class DogsController < ApplicationController
  helper_method :sort_column, :sort_direction, :is_fostering_dog?

  autocomplete :breed, :name, :full => true

  before_filter :authenticate,                            :except => [:index, :show]
  before_filter :edit_dog_check,                          :only => [:edit, :update]    
  # before_filter :fostering_dog_user, :edit_dogs_user,     :only => [:edit, :update]                                   
  before_filter :add_dogs_user,                          :only => [:new, :create]
  before_filter :admin_user,                              :only => [:destroy]

  def index
    is_manager = signed_in? && session[:mgr_view]

    @title = is_manager ? "Dog Manager" : "Our Dogs"
    @dogs = DogSearcher.search(params: params, manager: is_manager)

    respond_to do |format|
      format.html 
      format.json { render :json => @dogs.map(&:attributes) }
    end
  end

  def show
    @dog = Dog.find(params[:id])
    sort_dog_photos
    @title = @dog.name
  end

  def new
    @dog = Dog.new
    load_instance_variables
    @title = "Add a New Dog"
  end

  def edit
    @dog = Dog.find(params[:id]) 
    @dog.primary_breed_name = @dog.primary_breed.name unless @dog.primary_breed.nil?
    @dog.secondary_breed_name = @dog.secondary_breed.name unless @dog.secondary_breed.nil?
    sort_dog_photos
    load_instance_variables
    @title = "Edit Dog"
  end

  def update
    @dog = Dog.find(params[:id])
    if @dog.update_attributes(params[:dog])
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
    @dog = Dog.new(params[:dog])
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
    Dog.find(params[:id]).destroy
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

    def sort_dog_photos
      @dog.photos.sort_by!{|photo| photo.position}
    end

    def load_instance_variables
      5.times { @dog.photos.build }
      5.times { @dog.attachments.build }
      @foster_users = User.where(:is_foster => true).order("name")
      @coordinator_users = User.where(:edit_all_adopters => true).order("name")
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
