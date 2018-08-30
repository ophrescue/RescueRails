require 'rails_helper'

describe AttachmentsController, type: :controller do

  let!(:user) { create(:user) }

  describe 'GET #show' do
    context 'logged in with standard folder access' do
      before :each do
        allow(controller).to receive(:current_user) { user }
      end

      it 'can access attachments' do
        an_attachment = create(:attachment)
        get :show, params: { id: an_attachment }
        expect(response).to have_http_status(302)
        expect(response).not_to redirect_to('/signin')
      end
    end

    context 'not logged in' do

      it 'can not access attachments' do
        an_attachment = create(:attachment)
        get :show, params: { id: an_attachment }
        expect(response).to redirect_to('/signin')
      end

    end
  end

end
