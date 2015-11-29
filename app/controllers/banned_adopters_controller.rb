class BannedAdoptersController < ApplicationController

  before_filter :authenticate
  before_filter :ban_adopters_user, only: [:new, :create, :destroy, :edit, :update, :import]


  def index
    @title = "Do Not Adopt List"
    @banned_adopters = BannedAdopter.order(:name)
    respond_to do |format|
      format.html
      format.xls {send_data @banned_adopters.to_xls(filename: 'banned_adopters.xls', columns: [:id, :name, :phone, :email, :city, :state, :comment], headers: ['id', 'Name', 'Phone Number', 'Email Address', 'City', 'State', 'Comment'])}
    end
  end

  def show
    @banned_adopter = BannedAdopter.find(params[:id])
    @title = @banned_adopter.name
  end

  def new
    @title = "Add a Banned Adopter"
    @banned_adopter = BannedAdopter.new
  end

  def create
    @banned_adopter = BannedAdopter.new(banned_adopter_params)
    if @banned_adopter.save
      flash[:success] = "New Banned Adopter Added"
      redirect_to banned_adopters_path
    else
      @title = "Add a Banned Adopter"
      render 'new'
    end
  end

  def edit
    @title = "Edit"
    @banned_adopter = BannedAdopter.find(params[:id])
  end

  def update
    @banned_adopter = BannedAdopter.find_by_id(params[:id])
    if @banned_adopter.update_attributes(banned_adopter_params)
      flash[:success] = "Record updated."
      redirect_to banned_adopters_path
    else
      @title = "Edit"
      render 'edit'
    end
  end

  # def import
  #   BannedAdopter.import(params[:file])
  #   flash[:success] = "Banned Adopter List Imported."
  #   redirect_to banned_adopters_path
  # end


  private

    def ban_adopters_user
        redirect_to(root_path) unless current_user.ban_adopters?
    end

    def banned_adopter_params
      params.require(:banned_adopter).permit( :name,
                                              :phone,
                                              :email,
                                              :city,
                                              :state,
                                              :comment)
    end

end
