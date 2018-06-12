# == Schema Information
#
# Table name: folders
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  locked      :boolean          default(FALSE)
#

require 'rails_helper'

describe FoldersController, type: :controller do
  let!(:admin) { create(:user, :admin) }
  let!(:no_access_user) { create(:user, dl_resources: false) }
  let!(:dl_resources_user) { create(:user, dl_resources: true, dl_locked_resources: false) }

  describe 'GET #index' do
    context 'logged in with standard folder access' do
      before do
        sign_in_as(dl_resources_user)
      end

      it 'is successful' do
        get :index
        expect(response).to be_successful
      end
    end
  end

  describe 'GET #show' do
    context 'logged in with standard folder access' do
      before do
        sign_in_as(dl_resources_user)
      end

      it 'is able to view files in standard folders' do
        unlocked_folder = create(:folder, :unlocked)
        get :show, params: { id: unlocked_folder }
        expect(assigns(:folder)).to eq unlocked_folder
      end

      it 'is NOT able to view files in restricted folders' do
        locked_folder = create(:folder, :locked)
        get :show, params: { id: locked_folder }
        expect(response).to redirect_to folders_path
      end
    end

    context 'logged in without any folder access' do
      before do
        sign_in_as(no_access_user)
      end

      it 'is NOT able to view files in standard folders' do
        unlocked_folder = create(:folder, :unlocked)
        get :show, params: { id: unlocked_folder }
        expect(response).to redirect_to root_path
      end

      it 'is NOT able to view files in restricted folders' do
        locked_folder = create(:folder, :locked)
        get :show, params: { id: locked_folder }
        expect(response).to redirect_to root_path
      end
    end

    context 'logged in with restricted folder access' do
      include_context 'signed in admin'

      it 'is able to view files in standard folders' do
        unlocked_folder = create :folder
        get :show, params: { id: unlocked_folder }
        expect(assigns(:folder)).to eq unlocked_folder
      end

      it 'is able to view files in restricted folders' do
        locked_folder = create(:folder, :locked)
        get :show, params: { id: locked_folder }
        expect(assigns(:folder)).to eq locked_folder
      end
    end
  end

  describe 'GET #new' do
    include_context 'signed in admin'

    it 'is successful' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'PUT #update' do
    include_context 'signed in admin'

    let(:folder) { create(:folder) }

    it 'is successful' do
      put :update, params: { id: folder.id, folder: { name: 'Big Folder' } }
      expect(flash[:success]).to be_present
      expect(response).to redirect_to folder_path(folder)
    end
  end

  describe 'POST #create' do
    include_context 'signed in admin'

    it 'is successful' do
      request.env['HTTP_REFERER'] = '/'
      post :create, params: { folder: attributes_for(:folder) }
      expect(flash[:success]).to be_present
      expect(response).to redirect_to root_path
    end
  end

  describe 'GET #edit' do
    include_context 'signed in admin'

    let(:folder) { create(:folder) }

    it 'is successful' do
      get :edit, params: { id: folder.id }
      expect(response).to be_successful
    end
  end

  describe 'DELETE #destroy' do
    include_context 'signed in admin'

    let(:folder) { create(:folder) }

    it 'is successful' do
      request.env['HTTP_REFERER'] = '/'
      delete :destroy, params: { id: folder.id }
      expect(flash[:success]).to be_present
      expect(response).to redirect_to root_path
    end
  end
end
