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
#  adoptapet_ad_url     :string(255)
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

describe DogsController, type: :controller do
  let!(:admin) { create(:user, :admin) }

  describe 'GET #index' do
    context 'user is logged in' do
      let!(:adoptable_dog) { create(:dog, name: 'adoptable', status: 'adoptable') }
      let!(:adoption_pending_dog) { create(:dog, name: 'adoption pending', status: 'adoption pending', is_special_needs: false) }
      let!(:coming_soon_dog) { create(:dog, name: 'coming soon', status: 'coming soon', is_special_needs: false) }
      let!(:adopted_dog) { create(:dog, name: 'adopted', status: 'adopted', is_special_needs: false) }
      let!(:on_hold_dog) { create(:dog, name: 'on hold', status: 'on hold', is_special_needs: false) }
      let!(:not_available_dog) { create(:dog, name: 'not available', status: 'not available', is_special_needs: false) }
      let!(:baby_small_special_needs_dog) { create(:dog, name: 'filter pup' , status: 'adoptable', age: 'baby', size: 'small', is_special_needs: true) }

      let(:params) { {} }

      before do
        allow(controller).to receive(:signed_in?).and_return(true)
      end

      it 'in manager mode all dogs are returned' do
        get :index, params: {}, session: { mgr_view: true }
        expect(assigns(:dogs)).to match_array([adoptable_dog, adoption_pending_dog, coming_soon_dog, adopted_dog, on_hold_dog, not_available_dog, baby_small_special_needs_dog])
      end

      it 'in gallery mode only publicly viewable dogs are returned' do
        get :index, params: {}, session: { mgr_view: false }
        expect(assigns(:dogs)).to match_array([adoptable_dog, adoption_pending_dog, coming_soon_dog, baby_small_special_needs_dog])
      end

      it 'with all dogs paramater set all dogs are returned' do
        get :index, params: {all_dogs: true}, session: { mgr_view: true }
        expect(assigns(:dogs)).to match_array([adoptable_dog, adoption_pending_dog, coming_soon_dog, adopted_dog, on_hold_dog, not_available_dog, baby_small_special_needs_dog])
      end

      it 'can filter by age, size and flags' do
        get :index, params: {is_age: 'baby', is_size: 'small', cb_special_needs: true}, session: {mgr_view: true }
        expect(assigns(:dogs)).to match_array([baby_small_special_needs_dog])
      end
    end

    context 'public user' do
      let!(:adoptable_dog) { create(:dog, status: 'adoptable') }
      let!(:adoption_pending_dog) { create(:dog, status: 'adoption pending') }
      let!(:coming_soon_dog) { create(:dog, status: 'coming soon') }
      let!(:adopted_dog) { create(:dog, status: 'adopted') }
      let!(:on_hold_dog) { create(:dog, status: 'on hold') }
      let!(:not_available_dog) { create(:dog, status: 'not available') }

      subject(:get_index) { get :index, params: {} }

      it 'Only adoptable, adoption pending or coming soon dogs should be displayed' do
        get_index
        expect(assigns(:dogs)).to match_array([adoptable_dog, adoption_pending_dog, coming_soon_dog])
      end
    end
  end

  describe 'GET #show' do
    include_context 'signed in admin'

    let(:dog) { create(:dog) }

    it 'is successful' do
      get :show, params: { id: dog.id }
      expect(response).to be_success
    end
  end

  describe 'GET #edit' do
    include_context 'signed in admin'

    let(:dog) { create(:dog) }

    it 'is successful' do
      get :edit, params: { id: dog.id }
      expect(response).to be_success
    end
  end

  describe 'PUT update' do
    let(:test_dog) { create(:dog, name: 'Old Dog Name', behavior_summary: 'Mean Doggy') }
    let(:request) { -> { put :update, params: { id: test_dog.id, dog: attributes_for(:dog, name: 'New Dog Name', behavior_summary: 'This is a good doggy') } } }

    context 'logged in as admin' do
      before :each do
        allow(controller).to receive(:current_user) { admin }
      end

      it 'updates the dog name' do
        expect { request.call }.to change { test_dog.reload.name }.from('Old Dog Name').to('New Dog Name')
      end

      it 'updates the behavior summary' do
        expect { request.call }.to change { test_dog.reload.behavior_summary }.from('Mean Doggy').to('This is a good doggy')
      end
    end
  end

  describe 'POST create' do
    context 'logged in as dog adder admin' do
      subject(:post_create) do
        post :create, params: { dog: attributes_for(:dog_with_photo_and_attachment) }
      end

      before do
        allow(controller).to receive(:current_user) { admin }
      end

      context 'params are valid' do
        it 'is able to create a dog' do
          expect { post_create }.to change(Dog, :count).by(1)
        end

        it 'redirects to dogs#index' do
          post_create
          expect(response).to redirect_to(dogs_path)
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
  end

  describe 'GET switch_view' do
    let(:request) { get :switch_view, params: {}, session: { mgr_view: mgr_view } }
    let(:mgr_view) { true }

    before do
      allow(controller).to receive(:current_user) { admin }
      request
    end

    context 'mgr_view is true' do
      let(:mgr_view) { true }

      it 'sets mgr_view to false' do
        expect(session[:mgr_view]).to eq(false)
      end
    end

    context 'mgr_view is false' do
      let(:mgr_view) { false }

      it 'sets mgr_view to true' do
        expect(session[:mgr_view]).to eq(true)
      end
    end

    it 'redirects to /dogs' do
      expect(response).to redirect_to dogs_path
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
