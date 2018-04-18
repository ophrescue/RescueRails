require 'rails_helper'

describe EventsController, type: :controller do
  describe 'GET #index' do
    it 'is successful' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #past' do
    include_context 'signed in admin'

    it 'is successful' do
      get :past
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    let(:event) { create(:event) }

    it 'is successful' do
      get :show, params: { id: event.id }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    include_context 'signed in admin'

    it 'is successful' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    include_context 'signed in admin'

    let(:event) { create(:event) }

    it 'is successful' do
      get :edit, params: { id: event.id }
      expect(response).to be_successful
    end
  end

  describe 'PUT #update' do
    include_context 'signed in admin'

    let(:event) { create(:event) }

    it 'is successful' do
      put :update, params: { id: event.id, event: { title: 'Event' } }
      expect(flash[:success]).to be
      expect(response).to redirect_to events_path
    end
  end

  describe 'POST #create' do
    include_context 'signed in admin'

    it 'is successful' do
      post :create, params: { event: attributes_for(:event) }
      expect(flash[:success]).to be
      expect(response).to redirect_to events_path
    end
  end

  describe 'POST #delete' do
    include_context 'signed in admin'

    let(:event) { create(:event) }

    it 'is successful' do
      delete :destroy, params: { id: event.id }
      expect(flash[:danger]).to be
      expect(response).to redirect_to events_path
    end
  end
end
