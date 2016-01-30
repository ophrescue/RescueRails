# == Schema Information
#
# Table name: shelters
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SheltersController < ApplicationController

  before_filter :authenticate
  before_filter :edit_dogs_user


  def index
    @title = "Source Shelters"
    @shelters = Shelter.order(:id)
    respond_to do |format|
      format.html
    end
  end

  def show
    @shelter = Shelter.find(params[:id])
    @title = @shelter.name
  end

  def new
    @title = "Add a Source Shelter"
    @shelter = Shelter.new
  end

  def create
    @shelter = Shelter.new(shelter_params)
    if @shelter.save
      flash[:success] = "New Source Shelter Added"
      redirect_to shelters_path
    else
      @title = "Add a Source Shelter"
      render 'new'
    end
  end

  def edit
    @title = "Edit"
    @shelter = Shelter.find(params[:id])
  end

  def update
    @shelter = Shelter.find(params[:id])
      if @shelter.update_attributes(shelter_params)
        flash[:success] = "Record updated."
        redirect_to shelters_path
      else
        @title = "Edit"
        render 'edit'
      end
  end

  private

    def edit_dogs_user
      redirect_to(root_path) unless current_user.edit_dogs?
    end

    def shelter_params
      params.require(:shelter).permit(:name)
    end

end
