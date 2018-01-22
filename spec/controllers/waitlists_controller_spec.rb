# == Schema Information
#
# Table name:  waitlists
# id            :integer not null, primary key
# name          :string
# description   :text
# created_at    :datetime
# updated_at    :datetime
#
require 'rails_helper'

describe WaitlistsController, type: :controller do
  let!(:hacker) { create(:user) }

  describe 'GET #index' do
    context 'user is logged in' do
      let!(:waitlist) { create(:waitlist, name:'Puppy Waitlist') }

      before do
        allow(controller).to receive(:signed_in?).and_return(true)
      end

      it 'can see all waitlists' do
        get :index
        expect(response).to be_success
      end
    end
  end

  describe 'GET #show' do
    include_context 'signed in admin'

    let!(:waitlist) { create(:waitlist, name:'Puppy Waitlist') }

    it 'is successful' do
      get :show, params: { id: waitlist.id }
      expect(response).to be_success
    end
  end

  describe 'GET #new' do
    include_context 'signed in admin'

    it 'is successful' do
      get :new
      expect(response).to be_success
    end
  end

  describe 'GET #edit' do
    include_context 'signed in admin'

    let!(:waitlist) { create(:waitlist, name:'Puppy Waitlist') }

    it 'is successful' do
      get :edit, params: { id: waitlist.id }
      expect(response).to be_success
    end
  end

  describe 'POST #create' do
    context 'logged in as admin' do
      include_context 'signed in admin'

      it 'is able to create a waitlist' do
        expect{
          post :create, params: { waitlist: attributes_for(:waitlist) }
        }.to change(Waitlist, :count).by(1)
      end
    end

    context 'logged in as normal user' do
      before :each do
        allow(controller).to receive(:current_user) { hacker }
      end

      it 'is unable to create a waitlist' do
        expect{
          post :create, params: { waitlist: attributes_for(:waitlist) }
        }.to_not change(Waitlist, :count)
      end
    end
  end
  
end
