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
  let!(:user) {create(:user, dl_resources: FALSE)}

  describe 'GET #show' do

    context 'logged in with standard folder access' do
      before :each do
        allow(controller).to receive(:current_user) { admin }
      end

      it 'is able to view files in standard folders' do
        folder = create(:folder)
        get :show, id: folder
        expect(assigns(:folder)).to eq folder
      end
      it 'is NOT able to view files in restricted folders'
    end


    context 'logged in without any folder access' do
      before :each do
        allow(controller).to receive(:current_user) { user }
      end
      it 'is NOT able to view files in standard folders' do
        folder = create(:folder)
        get :show, id: folder
        expect(assigns(:folders)).to match(nil)
      end

      it 'is NOT able to view files in restricted folders'
    end


    context 'logged in with restricted folder access' do
      it 'is able to view files in standard folders'
      it 'is able to view files in restricted folders'
    end
  end

end
