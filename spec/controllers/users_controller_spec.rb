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
#  state                        :string(255)
#  zip                          :string(255)
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
#  medical_behavior_permission  :boolean          defualt(FALSE)

require 'rails_helper'

describe UsersController, type: :controller do
  let!(:admin) { create(:user, :admin, name: 'Admin') }
  let!(:hacker) { create(:user, name: 'Hacker') }

  describe 'GET index' do
    let(:jones) { create(:user, name: 'Frank Jones') }

    context 'default index list' do
      before :each do
        allow(controller).to receive(:current_user) { admin }
      end

      it 'returns all users' do
        smith = create(:user, name: 'Jane Smith')
        get :index
        expect(assigns(:users)).to match_array([jones, smith, admin, hacker])
      end
    end

    context 'name search' do
      before :each do
        allow(controller).to receive(:current_user) { admin }
      end
      it 'returns the searched for user' do
        smith = create(:user, name: 'Jane Smithbot')
        get :index, params: { search: 'Smithbot' }
        expect(assigns(:users)).to match_array([smith])
      end
    end

    context 'email search' do
      before :each do
        allow(controller).to receive(:current_user) { admin }
      end
      it 'returns the searched for user email' do
        smith = create(:user, name: 'Jane Smithbot', email: 'b@test.com')
        get :index, params: { search: 'b@test.com' }
        expect(assigns(:users)).to match_array([smith])
      end
    end

    context 'location search' do
      before :each do
        allow(controller).to receive(:current_user) { admin }
      end
      it 'returns users near the searched location' do
        expect(User).to receive(:near).and_call_original
        get :index, params: { location: '21224' }
      end
    end

    context 'tab filter' do
      before :each do
        allow(controller).to receive(:current_user) { admin }
      end

      it 'returns the training team members' do
        smith = create(:user, name: 'Jane Smithbot', training_team: TRUE)
        get :index, params: { training_team: TRUE }
        expect(assigns(:users)).to match_array([smith])
      end

      it 'returns the newsletter team members' do
        smith = create(:user, name: 'Jane Smithbot', writes_newsletter: TRUE)
        get :index, params: { newsletter: TRUE }
        expect(assigns(:users)).to match_array([smith])
      end

      it 'returns the public relations team members' do
        smith = create(:user, name: 'Jane Smithbot', public_relations: TRUE)
        get :index, params: { public_relations: TRUE }
        expect(assigns(:users)).to match_array([smith])
      end

      it 'returns the fundraising team members' do
        smith = create(:user, name: 'Jane Smithbot', fundraising: TRUE)
        get :index, params: { fundraising: TRUE }
        expect(assigns(:users)).to match_array([smith])
      end

      it 'returns the translator team mebers' do
        smith = create(:user, name: 'Jane Smithbot', translator: TRUE)
        get :index, params: { translator: TRUE }
        expect(assigns(:users)).to match_array([smith])
      end
    end
  end

  describe 'POST create' do
    context 'logged in as an admin' do
      before :each do
        allow(controller).to receive(:current_user) { admin }
      end

      it 'is able to create a user' do
        expect{
          post :create, params: { user: attributes_for(:user) }
        }.to change(User, :count).by(1)
      end
    end

    context 'logged in as normal user' do
      before :each do
        allow(controller).to receive(:current_user) { hacker }
      end

      it 'is unable to create a user' do
        expect{
          post :create, params: { user: attributes_for(:user) }
        }.to change(User, :count).by(0)
      end
    end
  end

  describe 'PUT update' do
    let(:test_user) { create(:user, admin: FALSE) }
    let(:request) { -> { put :update, params: { id: test_user.id, user: attributes_for(:user, admin: TRUE) } } }

    context 'logged in as admin' do
      before :each do
        allow(controller).to receive(:current_user) { admin }
      end

      it 'updates the users permissions' do
        expect { request.call }.to change { test_user.reload.admin }.from(FALSE).to(TRUE)
      end
    end

    context 'logged in as normal user' do
      before :each do
        allow(controller).to receive(:current_user) { hacker }
      end

      it 'is unable to modify user permissions' do
        expect { request.call }.to_not change { test_user.reload.admin }
      end
    end
  end
end
