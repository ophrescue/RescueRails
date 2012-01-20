class DogsController < ApplicationController
  helper_method :sort_column, :sort_direction 

  autocomplete :breed, :name, :full => true

  before_filter :edit_dogs_user,   :except => [:index, :show, :delete]
  before_filter :admin_user,        :only => [:destroy]

  def index
    if (can_edit_dogs?) && (cookies[:mgr_view] == true)
      @title = "Dog Manager"
    else
      @title = "Available Dogs"
    end
    ## Need to support the dog select drop down in the adopt app as well!

    if params[:status] == 'active'
      statuses = ['adoptable', 'adoption pending', 'hold', 'return pending', 'coming soon']
      @dogs = Dog.where("status IN (?)", statuses).order(sort_column + ' ' + sort_direction).paginate(:per_page => 30, :page => params[:page]).includes(:photos, :primary_breed)
    elsif params.has_key? :status
      @dogs = Dog.where(:status => params[:status]).order(sort_column + ' ' + sort_direction).paginate(:per_page => 30, :page => params[:page]).includes(:photos, :primary_breed)
    else
      @dogs = Dog.where("name ilike ?", "%#{params[:q]}%").order(sort_column + ' ' + sort_direction).paginate(:per_page => 30, :page => params[:page]).includes(:photos, :primary_breed)
    end
    
    respond_to do |format|
      format.html 
      format.json { render :json => @dogs.map(&:attributes) }
    end
  end

  def show
    @dog = Dog.find(params[:id])
    @title = @dog.name
  end

  def new
    @dog = Dog.new
    3.times { @dog.photos.build }
    @foster_users = User.where(:is_foster => true)
    @title = "Add a New Dog"
  end

  def edit
    @foster_users = User.where(:is_foster => true)
    @dog = Dog.find(params[:id]) 
    @dog.primary_breed_name = @dog.primary_breed.name unless @dog.primary_breed.nil?
    @dog.secondary_breed_name = @dog.secondary_breed.name unless @dog.secondary_breed.nil?
    3.times { @dog.photos.build }
    @title = "Edit Dog"
  end

  def update
    @dog = Dog.find(params[:id])
    if @dog.update_attributes(params[:dog])
      flash[:success] = "Dog updated."
      redirect_to @dog
    else
      @title = "Edit Dog"
      render 'edit'
    end
  end

  def create
    @foster_users = User.all
    @dog = Dog.new(params[:dog])
    if @dog.save
      flash[:success] = "New Dog Added"
      redirect_to dogs_path
    else
      @title = "Add a New Dog"
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

    def edit_dogs_user
      redirect_to(root_path) unless current_user.edit_dogs?
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
        
    def sort_column  
      Dog.column_names.include?(params[:sort]) ? params[:sort] : "name"  
    end  
      
    def sort_direction  
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"  
    end  

end
