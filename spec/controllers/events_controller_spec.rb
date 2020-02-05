require 'rails_helper'

describe EventsController, type: :controller do
  context 'public user' do
    describe 'GET #index' do
      it 'is successful' do
        get :index
        expect(response).to be_successful
      end
    end

    describe 'GET #index, with upcoming scope' do
      let(:future_event){ create(:event, :in_the_future) }
      let(:past_event){ create(:event, :in_the_past) }

      it "shows future events" do
        get :index, params: { scope: "upcoming" }
        expect(response).to be_successful
        expect(assigns[:events]).to eq [ future_event ]
      end
    end

    describe "GET #index, with upcoming scope and pagination" do
      let(:event_one)   { create(:event, event_date: Date.today.advance(days: 5), start_time: '06:00:00') }
      let(:event_two)   { create(:event, event_date: Date.today.advance(days: 5), start_time: '06:00:00') }
      let(:event_three) { create(:event, event_date: Date.today.advance(days: 5), start_time: '06:00:00') }
      let(:event_four)  { create(:event, event_date: Date.today.advance(days: 5), start_time: '06:00:00') }

      it 'page 1 shows event one and two' do
        stub_const('EventsController::PER_PAGE',2)
        get :index, params: { scope: "upcoming" }
        expect(assigns(:events)).to match_array([event_one, event_two])
      end

      it 'page 2 shows event three and four' do
        stub_const('EventsController::PER_PAGE',2)
        get :index, params: { scope: "upcoming" }
        expect(assigns(:events)).to match_array([event_three, event_four])
      end
    end

    describe 'GET #index, with past scope' do
      let(:future_event){ create(:event, :in_the_future) }
      let(:past_event){ create(:event, :in_the_past) }

      it "shows future events" do
        get :index, params: { scope: "past" }
        expect(response).to be_successful
        expect(assigns[:events]).to eq [ past_event ]
      end
    end

    describe "GET #index, with past scope and pagination" do
      let(:event_one)   { create(:event, event_date: Date.today.advance(days: -5), start_time: '06:00:00') }
      let(:event_two)   { create(:event, event_date: Date.today.advance(days: -5), start_time: '06:00:00') }
      let(:event_three) { create(:event, event_date: Date.today.advance(days: -5), start_time: '06:00:00') }
      let(:event_four)  { create(:event, event_date: Date.today.advance(days: -5), start_time: '06:00:00') }

      it 'page 1 shows event one and two' do
        stub_const('EventsController::PER_PAGE',2)
        get :index, params: { scope: "past" }
        expect(assigns(:events)).to match_array([event_one, event_two])
      end

      it 'page 2 shows event three and four' do
        stub_const('EventsController::PER_PAGE',2)
        get :index, params: { scope: "past" }
        expect(assigns(:events)).to match_array([event_three, event_four])
      end
    end

    describe 'GET #show' do
      let(:event) { create(:event) }

      it 'is successful with valid id param' do
        get :show, params: { id: event.id }
        expect(response).to be_successful
        expect(assigns[:event]).to eq event
      end

      it 'is unsuccessful with invalid id param' do
        expect{ get :show, params: { id: 'hack_me_if_you_can' } }.to raise_exception ActiveRecord::RecordNotFound
        expect(assigns[:event]).to be_nil
      end
    end
  end

  context 'admin user' do
    include_context 'signed in admin'
    describe 'GET #new' do
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
        expect(response).to redirect_to(event_url(assigns(:event)))
      end
    end

    describe 'POST #create' do
      include_context 'signed in admin'

      subject(:post_create) do
        post :create, params: { event: attributes_for(:event) }
      end

      it 'is able to add event' do
        expect { post_create }.to change(Event, :count).by(1)
      end

      it 'is successful' do
        post_create
        expect(flash[:success]).to eq "New event added"
        expect(response).to redirect_to(event_url(assigns(:event)))
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
end
