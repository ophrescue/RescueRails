require 'rails_helper'

describe EventsController, type: :controller do
  describe 'GET #index' do
    it 'is successful' do
      get :index
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

    let(:event) { create(:event, :in_the_future) }

    it 'is successful' do
      put :update, params: { id: event.id, event: { title: 'Event' } }
      expect(flash[:success]).to eq "Event updated."
      expect(response).to redirect_to scoped_events_path('upcoming')
    end
  end

  describe 'POST #create' do
    include_context 'signed in admin'

    it 'is successful' do
      post :create, params: { event: attributes_for(:event) }
      expect(flash[:success]).to eq "New event added"
      expect(response).to redirect_to scoped_events_path('upcoming')
    end
  end

  describe 'POST #delete' do
    include_context 'signed in admin'

    let(:past_event) { create(:event, :in_the_past) }
    let(:future_event) { create(:event, :in_the_future) }

    it 'is successful, and redirects to the appropriate scope' do
      delete :destroy, params: { id: past_event.id }
      expect(flash[:notice]).to eq "Event deleted"
      expect(response).to redirect_to scoped_events_path('past')
    end

    it 'is successful, and redirects to the appropriate scope' do
      delete :destroy, params: { id: future_event.id }
      expect(flash[:notice]).to eq "Event deleted"
      expect(response).to redirect_to scoped_events_path('upcoming')
    end
  end
end
