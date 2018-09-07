require 'rails_helper'

describe AttachmentsController, type: :controller do
  describe 'GET #show' do
    let(:an_attachment) { create(:attachment) }

    context 'logged in with standard folder access' do
      include_context 'signed in user'

      it 'can access attachments' do
        get :show, params: { id: an_attachment }

        expect(response).to have_http_status(302)
        expect(response).not_to redirect_to('/sign_in')
      end
    end

    context 'not logged in' do
      it 'can not access attachments' do
        get :show, params: { id: an_attachment }

        expect(response).to redirect_to('/sign_in')
      end
    end
  end
end
