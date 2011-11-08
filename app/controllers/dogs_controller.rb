class DogsController < ApplicationController
  autocomplete :breed, :name, :full => true

  before_filter :admin_user,   :only => [:new, :edit, :create, :destroy]

  def index
    @title = "Dogs"
    @dogs = Dog.paginate(:page => params[:page])
  end

  def show
    @dog = Dog.find(params[:id])
    @title = @dog.name
  end

  def new
    @dog = Dog.new
    3.times { @dog.photos.build }
    @foster_users = User.all
    @title = "Add a New Dog"
  end

  def edit
    @foster_users = User.all
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
    3.times { @dog.photos.build }
    @dog.primary_breed_name = @dog.primary_breed.name unless @dog.primary_breed.nil?
    @dog.secondary_breed_name = @dog.secondary_breed.name unless @dog.secondary_breed.nil?
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

  private

    def admin_user
      redirect_to(root_path) unless is_admin?
    end


end
