require 'rails_helper'

describe FolderAttachmentsController do
  describe 'GET #index' do
    let!(:no_access_user) { create(:user, dl_resources: false) }

    context 'logged in with standard folder access' do
      before :each do
        sign_in_with(dl_resources_user.email, dl_resources_user.password)
      end

      context 'when no search params are submitted' do
        it 'is successful' do
          get :index

          expect(response).to be_successful
        end
      end

      context 'when search params are submitted' do
        it 'is successful' do
          get :index, params: { search: 'zyx' }

          expect(response).to be_successful
        end
      end
    end

    context 'logged in as no access user' do
      let!(:dl_resources_user) { create(:user, dl_resources: true, dl_locked_resources: false) }

      before :each do
        sign_in_with(no_access_user.email, no_access_user.password)
      end

      it 'redirects to sign in page' do
        get :index

        expect(response).to redirect_to root_path
      end
    end
  end
end
