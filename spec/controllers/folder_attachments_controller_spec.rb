require 'rails_helper'

describe FolderAttachmentsController do
  let!(:admin) { create(:user, :admin) }
  let!(:no_access_user) { create(:user, dl_resources: false) }
  let!(:dl_resources_user) { create(:user, dl_resources: true, dl_locked_resources: false) }

  describe 'GET #index' do
    context 'logged in with standard folder access' do
      before :each do
        allow(controller).to receive(:current_user) { dl_resources_user }
      end

      context 'when no search params are submitted' do
        it 'is successful' do
          get :index
          expect(response).to be_successful
        end
      end

      context 'when search params are submitted' do
        it 'is successful' do
          get :index, params: {search: "zyx"}
          expect(response).to be_successful
        end
      end
    end

    context 'logged in as no access user' do
      before :each do
        allow(controller).to receive(:current_user) { no_access_user }
      end

      it 'redirects to sign in page' do
        get :index
        expect(response).to redirect_to root_path
      end
    end
  end
end
