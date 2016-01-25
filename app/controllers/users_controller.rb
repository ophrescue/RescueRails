# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  encrypted_password     :string(255)
#  salt                   :string(255)
#  admin                  :boolean          default(FALSE)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  is_foster              :boolean          default(FALSE)
#  phone                  :string(255)
#  address1               :string(255)
#  address2               :string(255)
#  city                   :string(255)
#  state                  :string(255)
#  zip                    :string(255)
#  duties                 :string(255)
#  edit_dogs              :boolean          default(FALSE)
#  share_info             :text
#  edit_my_adopters       :boolean          default(FALSE)
#  edit_all_adopters      :boolean          default(FALSE)
#  locked                 :boolean          default(FALSE)
#  edit_events            :boolean          default(FALSE)
#  other_phone            :string(255)
#  lastlogin              :datetime
#  lastverified           :datetime
#  available_to_foster    :boolean          default(FALSE)
#  foster_dog_types       :text
#  complete_adopters      :boolean          default(FALSE)
#  add_dogs               :boolean          default(FALSE)
#  ban_adopters           :boolean          default(FALSE)
#  dl_resources           :boolean          default(TRUE)
#  agreement_id           :integer
#  house_type             :string(40)
#  breed_restriction      :boolean
#  weight_restriction     :boolean
#  has_own_dogs           :boolean
#  has_own_cats           :boolean
#  children_under_five    :boolean
#  has_fenced_yard        :boolean
#  can_foster_puppies     :boolean
#  parvo_house            :boolean
#  admin_comment          :text
#  is_photographer        :boolean          default(FALSE)
#  writes_newsletter      :boolean          default(FALSE)
#  is_transporter         :boolean          default(FALSE)
#  mentor_id              :integer
#  latitude               :float
#  longitude              :float
#  dl_locked_resources    :boolean          default(FALSE)
#

class UsersController < ApplicationController

  before_filter :authenticate
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: [:new, :create, :destroy]

  YES_NO_OPTIONS = [['Any', ''], ['Yes', 't'], ['No', 'f']]
  OWN_RENT_OPTIONS = [['Any', ''], ['Own', 'own'], ['Rent', 'rent']]

  def index
    @title = "Staff Directory"
    @options = YES_NO_OPTIONS
    @rent_options = OWN_RENT_OPTIONS

    if params[:search]
      @users = User.where('lower(name) LIKE ?', "%#{params[:search].downcase.strip}%").paginate(page: params[:page])
    elsif params[:location]
      @users = User.active.near(params[:location], 30).paginate(page: params[:page])
    else
      @users = User.active.filter(filtering_params).order("name").paginate(page: params[:page])
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
        params.require(:user).permit(:name,
                                     :email,
                                     :password,
                                     :password_confirmation,
                                     :admin,
                                     :is_foster,
                                     :phone,
                                     :address1,
                                     :address2,
                                     :city,
                                     :state,
                                     :zip,
                                     :duties,
                                     :edit_dogs,
                                     :share_info,
                                     :edit_my_adopters,
                                     :edit_all_adopters,
                                     :locked,
                                     :edit_events,
                                     :other_phone,
                                     :available_to_foster,
                                     :foster_dog_types,
                                     :complete_adopters,
                                     :add_dogs,
                                     :ban_adopters,
                                     :dl_resources,
                                     :agreement_id,
                                     :house_type,
                                     :breed_restriction,
                                     :weight_restriction,
                                     :has_own_dogs,
                                     :has_own_cats,
                                     :children_under_five,
                                     :has_fenced_yard,
                                     :can_foster_puppies,
                                     :parvo_house,
                                     :admin_comment,
                                     :is_photographer,
                                     :writes_newsletter,
                                     :is_transporter,
                                     :mentor_id,
                                     :lastverified
          )
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
      @foster_users = User.where(locked: false).order("name")
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless (current_user?(@user) || current_user.admin?)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def filtering_params
      params.slice(:admin, :adoption_coordinator, :event_planner,
                   :dog_adder, :dog_editor, :photographer, :foster,
                   :newsletter, :has_dogs, :has_cats, :house_type, :has_children_under_five,
                   :has_fence, :puppies_ok, :has_parvo_house, :transporter
                  )
    end

end
