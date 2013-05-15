class FoldersController < ApplicationController

  before_filter :dl_resource_user
  before_filter :admin_user, :only => [:new, :create, :edit, :update, :destroy]

  def index
  	@title = "Staff Resources"
  	@folders = Folder.all
    @folders.each do |a|
      a.attachments.build
    end
  end

  def show
  	@folder = Folder.find(params[:id])
  	@folder.attachments.build
  	@title = @folder.name
  end

  def new
  	@folder = Folder.new
  	@title = "Create a New Folder"
  end

  def create
  	@folder = Folder.new(params[:folder])
  	if @folder.save
  		flash[:success] = "New Folder Added"
  		redirect_to folders_path
    end
  end

  def update
  	@folder = Folder.find(params[:id])
  	if @folder.update_attributes(params[:folder])
  		flash[:success] = "Folder Updated"
  		redirect_to folders_path
  	else
      @title = "Edit Folder"
      render 'edit'
    end
  end


  def edit
  	@folder = Foster.find(params[:id])
  	@folder.attachments.build
  	@title = "Edit Folder"
  end

  def destroy
  	Folder.find(params[:id]).destroy
  	flash[:success] = "Folder Deleted"
  	redirect_to folders_path
  end

  private

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def dl_resource_user
      redirect_to(root_path) unless current_user.dl_resources?
    end

end
