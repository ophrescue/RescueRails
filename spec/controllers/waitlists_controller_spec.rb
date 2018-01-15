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
  let!(:waitlist) { create(:waitlist, name:'Puppy Waitlist') }

  describe 'GET #index' do
    context 'user is logged in' do
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

    it 'is successful' do
      get :show, params: { id: waitlist.id }
      expect(response).to be_success
    end
  end
end
