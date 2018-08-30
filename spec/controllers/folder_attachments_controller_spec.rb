require 'rails_helper'

describe FolderAttachmentsController do
  before :each do
    sign_in_as(user)
  end

  describe 'GET #index' do
    let!(:user) { create(:user, dl_resources: true, dl_locked_resources: false) }

    context 'logged in with standard folder access' do
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
      let!(:user) { create(:user, dl_resources: false) }

      it 'redirects to sign in page' do
        get :index

        expect(response).to redirect_to root_path
      end
    end
  end
end
