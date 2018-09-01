#    Copyright 2017 Operation Paws for Homes
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

# == Schema Information
#
# Table name: users
#
#  id                           :integer          not null, primary key
#  name                         :string(255)
#  email                        :string(255)
#  created_at                   :datetime
#  updated_at                   :datetime
#  encrypted_password           :string(255)
#  salt                         :string(255)
#  admin                        :boolean          default(FALSE)
#  password_reset_token         :string(255)
#  password_reset_sent_at       :datetime
#  is_foster                    :boolean          default(FALSE)
#  phone                        :string(255)
#  address1                     :string(255)
#  address2                     :string(255)
#  city                         :string(255)
#  region                       :string(2)
#  postal_code                  :string(255)
#  duties                       :string(255)
#  edit_dogs                    :boolean          default(FALSE)
#  share_info                   :text
#  edit_my_adopters             :boolean          default(FALSE)
#  edit_all_adopters            :boolean          default(FALSE)
#  locked                       :boolean          default(FALSE)
#  edit_events                  :boolean          default(FALSE)
#  other_phone                  :string(255)
#  lastlogin                    :datetime
#  lastverified                 :datetime
#  available_to_foster          :boolean          default(FALSE)
#  foster_dog_types             :text
#  complete_adopters            :boolean          default(FALSE)
#  add_dogs                     :boolean          default(FALSE)
#  ban_adopters                 :boolean          default(FALSE)
#  dl_resources                 :boolean          default(TRUE)
#  agreement_id                 :integer
#  house_type                   :string(40)
#  breed_restriction            :boolean
#  weight_restriction           :boolean
#  has_own_dogs                 :boolean
#  has_own_cats                 :boolean
#  children_under_five          :boolean
#  has_fenced_yard              :boolean
#  can_foster_puppies           :boolean
#  parvo_house                  :boolean
#  admin_comment                :text
#  is_photographer              :boolean          default(FALSE)
#  writes_newsletter            :boolean          default(FALSE)
#  is_transporter               :boolean          default(FALSE)
#  mentor_id                    :integer
#  latitude                     :float
#  longitude                    :float
#  dl_locked_resources          :boolean          default(FALSE)
#  training_team                :boolean          default(FALSE)
#  confidentiality_agreement_id :integer
#  medical_behavior_permission  :boolean          default(FALSE)
#  boarding_buddies             :boolean          default(FALSE)
#  social_media_manager         :boolean          default(FALSE)
#  graphic_design               :boolean          default(FALSE)
class UsersController < Clearance::UsersController
  before_action :require_login
  before_action :correct_user, only: [:edit, :update]
  before_action :active_user, only: [:index]
  before_action :allowed_to_see_user, only: [:show]
  before_action :admin_user, only: [:new, :create, :destroy]

  YES_NO_OPTIONS = [['Any', ''], ['Yes', 't'], ['No', 'f']]
  OWN_RENT_OPTIONS = [['Any', ''], ['Own', 'own'], ['Rent', 'rent']]

  def index
    @options = YES_NO_OPTIONS
    @rent_options = OWN_RENT_OPTIONS
    @users = UserSearcher.search(params: params)
    respond_to do |format|
      format.html
      if current_user.admin?
        format.xls { render_users_xls }
      else
        format.xls { head :forbidden }
      end
    end
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def new
    @user = User.new
    init_fields
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'Account created for ' + @user.name
      redirect_to users_path
    else
      @user.password = ""
      init_fields
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    init_fields
  end

  def update
    if @user.update(update_user_params)
      flash[:success] = 'Profile updated.'
      redirect_to @user
    else
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

  def update_user_params
    p = user_params
    p.delete(:password) if p[:password].blank?
    p[:lastverified] = Time.now

    p
  end

  def user_params
    if current_user && current_user.admin?
      params.require(:user)
        .permit(:name,
                :email,
                :password,
                :admin,
                :is_foster,
                :phone,
                :address1,
                :address2,
                :city,
                :region,
                :postal_code,
                :country,
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
                :dl_locked_resources,
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
                :training_team,
                :foster_mentor,
                :public_relations,
                :fundraising,
                :lastverified,
                :agreement_id,
                :confidentiality_agreement_id,
                :translator,
                :known_languages,
                :medical_behavior_permission,
                :boarding_buddies,
                :social_media_manager,
                :graphic_design,
                :active,
                agreement_attributes: [
                  :attachment,
                  :description,
                  :updated_by_user_id,
                  :_destroy,
                  :id
                ],
                confidentiality_agreement_attributes: [
                  :attachment,
                  :description,
                  :updated_by_user_id,
                  :_destroy,
                  :id
                ],
                code_of_conduct_agreement_attributes: [
                  :attachment,
                  :description,
                  :updated_by_user_id,
                  :_destroy,
                  :id
                ])
    else
      params.require(:user)
        .permit(:password,
                :phone,
                :other_phone,
                :address1,
                :address2,
                :city,
                :region,
                :postal_code,
                :country,
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
                :mentor_id,
                :translator,
                :known_languages)
    end
  end

  def init_fields
    @user.build_agreement unless @user.agreement
    @user.build_confidentiality_agreement unless @user.confidentiality_agreement
    @user.build_code_of_conduct_agreement unless @user.code_of_conduct_agreement
    @foster_users = User.where(locked: false).order("name")
  end

  def active_user
    redirect_to(root_path) unless current_user.active?
  end

  def allowed_to_see_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless (current_user?(@user) || current_user.active?)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless (current_user?(@user) || current_user.admin?)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def render_users_xls
    send_data @users.to_xls(
      columns: [
        :id,
        :name,
        :email,
        :phone,
        :address1,
        :address2,
        :city,
        :region
      ],
      headers: [
        'id',
        'Name',
        'Email',
        'Phone',
        'Address 1',
        'Address 2',
        'City',
        'State'
      ]
    ),
    filename: 'users.xls'
  end

  def redirect_signed_in_users; end
end
