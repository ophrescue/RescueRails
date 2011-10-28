class DogsController < ApplicationController
  autocomplete :breed, :name, :full => true

  before_filter :admin_user,   :only => [:new, :create, :destroy]

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
    @title = "Add a New Dog"
  end

  def edit
    @dog = Dog.find(params[:id])
    @title = "Edit Dog"
    debugger
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
      redirect_to(root_path) unless current_user.admin?
    end


end
