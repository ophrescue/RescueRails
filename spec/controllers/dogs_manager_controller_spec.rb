# == Schema Information
#
# Table name: dogs
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  tracking_id          :integer
#  primary_breed_id     :integer
#  secondary_breed_id   :integer
#  status               :string(255)
#  age                  :string(75)
#  size                 :string(75)
#  is_altered           :boolean
#  gender               :string(6)
#  is_special_needs     :boolean
#  no_dogs              :boolean
#  no_cats              :boolean
#  no_kids              :boolean
#  description          :text
#  foster_id            :integer
#  adoption_date        :date
#  is_uptodateonshots   :boolean          default(TRUE)
#  intake_dt            :date
#  available_on_dt      :date
#  has_medical_need     :boolean          default(FALSE)
#  is_high_priority     :boolean          default(FALSE)
#  needs_photos         :boolean          default(FALSE)
#  has_behavior_problem :boolean          default(FALSE)
#  needs_foster         :boolean          default(FALSE)
#  petfinder_ad_url     :string(255)
#  craigslist_ad_url    :string(255)
#  youtube_video_url    :string(255)
#  first_shots          :string(255)
#  second_shots         :string(255)
#  third_shots          :string(255)
#  rabies               :string(255)
#  heartworm            :string(255)
#  bordetella           :string(255)
#  microchip            :string(255)
#  original_name        :string(255)
#  fee                  :integer
#  coordinator_id       :integer
#  sponsored_by         :string(255)
#  shelter_id           :integer
#  medical_summary      :text
require 'rails_helper'

describe Dogs::ManagerController, type: :controller do

  describe 'GET #index' do
    context 'user is logged in' do
      include_context 'signed in admin'

      context 'and user is active' do
        let!(:admin) { create(:user, :admin) }
        let!(:adoptable_dog) { create(:dog, name: 'adoptable', status: 'adoptable', is_special_needs: false) }
        let!(:adoption_pending_dog) { create(:dog, name: 'adoption pending', status: 'adoption pending', is_special_needs: false) }
        let!(:coming_soon_dog) { create(:dog, name: 'coming soon', status: 'coming soon', is_special_needs: false) }
        let!(:adopted_dog) { create(:dog, name: 'adopted', status: 'adopted', is_special_needs: false) }
        let!(:on_hold_dog) { create(:dog, name: 'on hold', status: 'on hold', is_special_needs: false) }
        let!(:not_available_dog) { create(:dog, name: 'not available', status: 'not available', is_special_needs: false) }
        let!(:baby_small_special_needs_dog) { create(:dog, name: 'filter pup' , status: 'adoptable', age: 'baby', size: 'small', is_special_needs: true) }

        let(:params) { {} }

        it 'should set default sort and direction if no params are supplied' do
          get :index, params {}
          expect(assigns(:dogs)).to match_array([adoptable_dog, adoption_pending_dog, coming_soon_dog, adopted_dog, on_hold_dog, not_available_dog, baby_small_special_needs_dog])
          expect(assigns(:filter_params)[:sort]).to eq "tracking_id"
          expect(assigns(:filter_params)[:direction]).to eq "desc"
        end

        it 'all dogs are returned in #index' do
          get :index, params: {filter_params: { sort: 'tracking_id', direction: 'asc'}}
          expect(assigns(:dogs)).to match_array([adoptable_dog, adoption_pending_dog, coming_soon_dog, adopted_dog, on_hold_dog, not_available_dog, baby_small_special_needs_dog])
          expect(assigns(:filter_params)[:sort]).to eq "tracking_id"
          expect(assigns(:filter_params)[:direction]).to eq "desc"
        end

        it 'returns excel list of dogs' do
          get :index, format: :xls
          expect(response).to have_http_status(200)
          expect(response.headers["Content-Type"]).to eq "application/xls"
        end

        it 'can filter by age, size and flags' do
          get :index, params: {filter_params: {is_age: 'baby', is_size: 'small', has_flags: ['special_needs']}}
          expect(assigns(:dogs)).to match_array([baby_small_special_needs_dog])
        end
      end

      context 'and user is not active' do
        let!(:admin) { create(:user, :admin, active: false) }
        subject(:get_index) { get :index, params: {} }

        it 'redirects to gallery page' do
          expect(subject).to redirect_to(dogs_path)
        end
      end
    end

    context 'public user, not logged in' do
      let!(:dog) { create(:dog) }

      subject(:get_index) { get :index, params: {} }

      it 'redirected to signin' do
        expect(subject).to redirect_to(signin_path)
        expect(assigns(:dogs)).to be_nil
      end
    end
  end

  describe 'GET #show' do
    include_context 'signed in admin'

    let(:dog) { create(:dog) }

    it 'is successful' do
      get :show, params: { id: dog.id }
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    let(:dog) { create(:dog) }
    include_context 'signed in admin'

    before do
      get :edit, params: { id: dog.id }
    end

    context 'user is admin with all privileges' do
      it 'is successful' do
        expect(response).to be_successful
      end
    end

    context 'user is admin without edit privilege' do
      let(:admin) { create(:user, :admin, edit_dogs: false) }

      it 'redirects' do
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user is admin without add privilege' do
      let(:admin) { create(:user, :admin, add_dogs: false) }

      it 'is successful' do
        expect(response).to be_successful
      end
    end
  end

  describe 'GET #new' do
    let(:dog) { create(:dog) }
    include_context 'signed in admin'

    before do
      get :new
    end

    context 'user is admin with all privileges' do
      it 'is successful' do
        expect(response).to be_successful
      end
    end

    context 'user is admin without edit privilege' do
      let(:admin) { create(:user, :admin, edit_dogs: false) }

      it 'is successful' do
        expect(response).to be_successful
      end
    end

    context 'user is admin without add privilege' do
      let(:admin) { create(:user, :admin, add_dogs: false) }

      it 'redirects' do
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'PUT update' do
    let(:test_dog) { create(:dog, name: 'Old Dog Name', behavior_summary: 'Mean Doggy', status: 'adoption pending', ) }
    let(:request) { -> { put :update, params: { id: test_dog.id, dog: { adoption_date: "2018-8-28", name: 'New Dog Name', behavior_summary: 'This is a good doggy'} } } }
    include_context 'signed in admin'

    context 'logged in as admin' do
      it 'updates the dog name and adoption date' do
        # status didn't change so it takes the date submitted by the user
        expect { request.call }.to change { test_dog.reload.name }.from('Old Dog Name').to('New Dog Name')
                               .and change { test_dog.adoption_date }.from(nil).to(Date.new(2018,8,28))
      end

      it 'redirects to dog#show' do
        request.call
        expect(response).to redirect_to(dogs_manager_path(test_dog))
      end

      it 'updates the behavior summary' do
        expect { request.call }.to change { test_dog.reload.behavior_summary }.from('Mean Doggy').to('This is a good doggy')
      end
    end

    context 'logged in as admin without edit privilege' do
      let(:admin) { create(:user, :admin, edit_dogs: false) }

      it 'redirects' do
        request.call
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST create' do
    context 'logged in as dog adder admin' do
      include_context 'signed in admin'
      subject(:post_create) do
        post :create, params: { dog: attributes_for(:dog_with_photo_and_attachment) }
      end

      context 'params are valid' do
        it 'is able to create a dog' do
          expect { post_create }.to change(Dog, :count).by(1)
        end

        it 'redirects to dogs_manager#index' do
          post_create
          expect(response).to redirect_to(dogs_manager_index_path)
        end

        context 'dog tracking id is blank' do
          let(:dog_params) { attributes_for(:dog_with_photo_and_attachment, tracking_id: nil) }

          it 'gets next value from tracking_id_seq' do
            expect(Dog).to receive(:next_tracking_id)

            post :create, params: { dog: dog_params }
          end
        end
      end
    end

    context 'admin does not have add_dog prvileges' do
      include_context 'signed in admin'
      let(:admin) { create(:user, :admin, add_dogs: false) }

      it 'redirects' do
        post :create, params: { dog: attributes_for(:dog_with_photo_and_attachment) }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'fostering_dog?' do
    subject { controller.send(:fostering_dog?) }

    context 'not signed in' do
      before do
        allow(controller).to receive(:signed_in?) { false }
      end

      it 'returns false' do
        expect(subject).to eq(false)
      end
    end

    context 'signed in' do
      include_context 'signed in admin'

      before do
        controller.instance_variable_set(:@dog, dog)
      end

      context 'dog foster is the current user' do
        let(:dog) { create(:dog, foster_id: admin.id) }

        it 'returns true' do
          expect(subject).to eq(true)
        end
      end

      context 'dog foster is not the current user' do
        let(:dog) { create(:dog, foster_id: admin.id + 1) }

        it 'returns false' do
          expect(subject).to eq(false)
        end
      end
    end
  end
end
