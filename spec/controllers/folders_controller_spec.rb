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

  let!(:admin) {create(:user, :admin)}
  let!(:no_access_user) {create(:user, dl_resources: FALSE)}
  let!(:dl_resources_user) {create(:user, dl_resources: TRUE, dl_locked_resources: FALSE)}

  describe 'GET #show' do

    context 'logged in with standard folder access' do
      before :each do
        allow(controller).to receive(:current_user) { dl_resources_user }
      end

      it 'is able to view files in standard folders' do
        unlocked_folder = create(:folder, :unlocked)
        get :show, id: unlocked_folder
        expect(assigns(:folder)).to eq unlocked_folder
      end

      it 'is NOT able to view files in restricted folders' do
        locked_folder = create(:folder, :locked)
        get :show, id: locked_folder
        expect(response).to redirect_to folders_path
      end
    end


    context 'logged in without any folder access' do
      before :each do
        allow(controller).to receive(:current_user) { no_access_user }
      end
      it 'is NOT able to view files in standard folders' do
        unlocked_folder = create(:folder, :unlocked)
        get :show, id: unlocked_folder
        expect(response).to redirect_to root_path
      end

      it 'is NOT able to view files in restricted folders' do
        locked_folder = create(:folder, :locked)
        get :show, id: locked_folder
        expect(response).to redirect_to root_path
      end
    end


    context 'logged in with restricted folder access' do
      before :each do
        allow(controller).to receive(:current_user) { admin }
      end
      it 'is able to view files in standard folders' do
        unlocked_folder = create :folder
        get :show, id: unlocked_folder
        expect(assigns(:folder)).to eq unlocked_folder
      end
      it 'is able to view files in restricted folders' do
        locked_folder = create(:folder, :locked)
        get :show, id: locked_folder
        expect(assigns(:folder)).to eq locked_folder
      end
    end
  end

end
