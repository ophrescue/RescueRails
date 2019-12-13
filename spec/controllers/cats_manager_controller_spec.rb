# == Schema Information
#
# Table name: cats
#
#  id                      :bigint           not null, primary key
#  name                    :string
#  original_name           :string
#  tracking_id             :integer
#  primary_breed_id        :integer
#  secondary_breed_id      :integer
#  status                  :string
#  age                     :string(75)
#  size                    :string(75)
#  is_altered              :boolean
#  gender                  :string(6)
#  declawed                :boolean
#  litter_box_trained      :boolean
#  coat_length             :string
#  is_special_needs        :boolean
#  no_dogs                 :boolean
#  no_cats                 :boolean
#  no_kids                 :boolean
#  description             :text
#  foster_id               :integer
#  adoption_date           :date
#  is_uptodateonshots      :boolean          default(TRUE)
#  intake_dt               :date
#  available_on_dt         :date
#  has_medical_need        :boolean          default(FALSE)
#  is_high_priority        :boolean          default(FALSE)
#  needs_photos            :boolean          default(FALSE)
#  has_behavior_problem    :boolean          default(FALSE)
#  needs_foster            :boolean          default(FALSE)
#  petfinder_ad_url        :string
#  craigslist_ad_url       :string
#  youtube_video_url       :string
#  microchip               :string
#  fee                     :integer
#  coordinator_id          :integer
#  sponsored_by            :string
#  shelter_id              :integer
#  medical_summary         :text
#  behavior_summary        :text
#  medical_review_complete :boolean          default(FALSE)
#  first_shots             :string
#  second_shots            :string
#  third_shots             :string
#  rabies                  :string
#  felv_fiv_test           :string
#  flea_tick_preventative  :string
#  dewormer                :string
#  coccidia_treatment      :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
require 'rails_helper'

describe Cats::ManagerController, type: :controller do
  describe 'GET #index' do
    context 'user is logged in' do
      include_context 'signed in admin'

      context 'and user is active' do
        let!(:admin) { create(:user, :admin) }
        let!(:adoptable_cat) { create(:cat, name: 'adoptable', status: 'adoptable', is_special_needs: false, age: 'senior') }
        let!(:adoption_pending_cat) { create(:cat, name: 'adoption pending', status: 'adoption pending', is_special_needs: false, age: 'senior') }
        let!(:coming_soon_cat) { create(:cat, name: 'coming soon', status: 'coming soon', is_special_needs: false, age: 'senior') }
        let!(:adopted_cat) { create(:cat, name: 'adopted', status: 'adopted', is_special_needs: false, age: 'senior') }
        let!(:on_hold_cat) { create(:cat, name: 'on hold', status: 'on hold', is_special_needs: false, age: 'baby') }
        let!(:not_available_cat) { create(:cat, name: 'not available', status: 'not available', is_special_needs: false, age: 'baby') }
        let!(:baby_small_special_needs_cat) { create(:cat, name: 'filter pup' , status: 'adoptable', age: 'baby', size: 'small', is_special_needs: true) }

        let(:params) { {} }

        it 'should set default sort and direction if no params are supplied' do
          get :index, params {}
          expect(assigns(:cats)).to match_array([adoptable_cat, adoption_pending_cat, coming_soon_cat, adopted_cat, on_hold_cat, not_available_cat, baby_small_special_needs_cat])
          expect(assigns(:filter_params)[:sort]).to eq "tracking_id"
          expect(assigns(:filter_params)[:direction]).to eq "desc"
        end

        it 'all cats are returned in #index' do
          get :index, params: {filter_params: { sort: 'tracking_id', direction: 'asc'}}
          expect(assigns(:cats)).to match_array([adoptable_cat, adoption_pending_cat, coming_soon_cat, adopted_cat, on_hold_cat, not_available_cat, baby_small_special_needs_cat])
          expect(assigns(:filter_params)[:sort]).to eq "tracking_id"
          expect(assigns(:filter_params)[:direction]).to eq "desc"
        end

        it 'returns excel list of cats' do
          get :index, format: :xls
          expect(response).to have_http_status(200)
          expect(response.headers["Content-Type"]).to eq "application/xls"
        end

        it 'returns excel list of all cats matching filter and sort, not limited by paging' do
          stub_const('Cats::CatsBaseController::PER_PAGE',2)
          get :index, format: :xls, params: {filter_params: {is_age: ['baby']}}
          expect(response).to have_http_status(200)
          expect(response.headers["Content-Type"]).to eq "application/xls"
          expect(assigns(:cats)).to match_array([on_hold_cat, not_available_cat, baby_small_special_needs_cat])
        end

        it 'can filter by age, size and flags' do
          get :index, params: {filter_params: {is_age: ['baby'], is_size: ['small'], has_flags: ['special_needs']}}
          expect(assigns(:cats)).to match_array([baby_small_special_needs_cat])
        end
      end

      context 'and user is not active' do
        let!(:admin) { create(:user, :admin, active: false) }
        subject(:get_index) { get :index, params: {} }

        it 'redirects to gallery page' do
          expect(subject).to redirect_to(cats_path)
        end
      end
    end

    context 'public user, not logged in' do
      let!(:cat) { create(:cat) }

      subject(:get_index) { get :index, params: {} }

      it 'redirected to signin' do
        expect(subject).to redirect_to(sign_in_path)
      end
    end
  end

  describe 'GET #show' do
    context 'public user' do
      let(:cat) { create(:cat) }

      it 'is redirected to the cat public profile' do
        get :show, params: { id: cat.id }
        expect(subject).to redirect_to(cat_path(cat.id))
      end
    end
    context 'signed in as admin' do
      include_context 'signed in admin'

      let(:cat) { create(:cat) }

      it 'is successful' do
        get :show, params: { id: cat.id }
        expect(response).to be_successful
      end
    end
  end

  describe 'GET #edit' do
    let(:cat) { create(:cat) }
    include_context 'signed in admin'

    before do
      get :edit, params: { id: cat.id }
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
    let(:cat) { create(:cat) }
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
    let(:test_cat) { create(:cat, name: 'Old Cat Name', behavior_summary: 'Mean Kitty', status: 'adoption pending', ) }
    let(:request) { -> { put :update, params: { id: test_cat.id, cat: { adoption_date: "2018-8-28", name: 'New Cat Name', behavior_summary: 'This is a good kitty'} } } }
    include_context 'signed in admin'

    context 'logged in as admin' do
      it 'updates the cat name and adoption date' do
        # status didn't change so it takes the date submitted by the user
        expect { request.call }.to change { test_cat.reload.name }.from('Old Cat Name').to('New Cat Name')
                               .and change { test_cat.adoption_date }.from(nil).to(Date.new(2018,8,28))
      end

      it 'redirects to cat#show' do
        request.call
        expect(response).to redirect_to(cats_manager_path(test_cat))
      end

      it 'updates the behavior summary' do
        expect { request.call }.to change { test_cat.reload.behavior_summary }.from('Mean Kitty').to('This is a good kitty')
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
    context 'logged in as cat adder admin' do
      include_context 'signed in admin'
      subject(:post_create) do
        post :create, params: { cat: attributes_for(:cat_with_photo_and_attachment) }
      end

      context 'params are valid' do
        it 'is able to create a cat' do
          expect { post_create }.to change(Cat, :count).by(1)
        end

        it 'redirects to cats_manager#index' do
          post_create
          expect(response).to redirect_to(cats_manager_index_path)
        end

        context 'cat tracking id is blank' do
          let(:cat_params) { attributes_for(:cat_with_photo_and_attachment, tracking_id: nil) }

          it 'gets next value from tracking_id_seq' do
            expect(Cat).to receive(:next_tracking_id)

            post :create, params: { cat: cat_params }
          end
        end
      end
    end

    context 'admin does not have add_cat prvileges' do
      include_context 'signed in admin'
      let(:admin) { create(:user, :admin, add_dogs: false) }

      it 'redirects' do
        post :create, params: { cat: attributes_for(:cat_with_photo_and_attachment) }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'fostering_cat?' do
    subject { controller.send(:fostering_cat?) }

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
        controller.instance_variable_set(:@cat, cat)
      end

      context 'cat foster is the current user' do
        let(:cat) { create(:cat, foster_id: admin.id) }

        it 'returns true' do
          expect(subject).to eq(true)
        end
      end

      context 'cat foster is not the current user' do
        let(:cat) { create(:cat, foster_id: admin.id + 1) }

        it 'returns false' do
          expect(subject).to eq(false)
        end
      end
    end
  end
end
