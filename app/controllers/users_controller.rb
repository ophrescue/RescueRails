class UsersController < ApplicationController

  before_filter :authenticate
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user, :only => [:new, :create, :destroy]

  YES_NO_OPTIONS = [['Any', ''], ['Yes', 't'], ['No', 'f']]
  OWN_RENT_OPTIONS = [['Any', ''], ['Own', 'own'], ['Rent', 'rent']]

  def index
    @title = "Staff Directory"
    @options = YES_NO_OPTIONS
    @rent_options = OWN_RENT_OPTIONS

    if params[:search]
      @users = User.where('lower(name) LIKE ?', "%#{params[:search].downcase.strip}%").paginate(:page => params[:page])
    else
      @users = User.active.filter(filtering_params).order("name").paginate(:page => params[:page])
    end
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def new
    @user = User.new
    @title = "Add a Staff Account"
    init_fields
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Account created for " + @user.name
      redirect_to users_path
    else
      @title = "Add a Staff Account"
      @user.password = ""
      @user.password_confirmation = ""
      init_fields
      render 'new'
    end
  end

  def edit
    @title = "Edit Profile"
    @user = User.find(params[:id])
    init_fields
  end

  def update
    if @user.update_attributes(user_params)
      @user.update_attribute(:lastverified, Time.now)
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit Profile"
      init_fields
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_path
  end

  private

    def user_params
      if current_user && current_user.admin?
        params.require(:user).permit!
      else
        params.require(:user).permit( :name,
                                      :email,
                                      :password,
                                      :password_confirmation,
                                      :phone,
                                      :other_phone,
                                      :address1,
                                      :address2,
                                      :city,
                                      :state,
                                      :zip,
                                      :duties,
                                      :share_info,
                                      :available_to_foster,
                                      :foster_dog_types,
                                      :house_type,
                                      :breed_restriction,
                                      :weight_restriction,
                                      :has_own_dogs,
                                      :has_own_cats,
                                      :children_under_five,
                                      :has_fenced_yard,
                                      :can_foster_puppies,
                                      :parvo_house,
                                      :is_transporter,
                                      :mentor_id)
      end
    end

    def init_fields
      @user.build_agreement unless @user.agreement
      @foster_users = User.where(:locked => false).order("name")
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless (current_user?(@user) || current_user.admin?)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
