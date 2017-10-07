require 'rails_helper'

describe PasswordResetsController, type: :controller do
  describe 'GET #edit' do
    let!(:user) { create(:user, password_reset_token: 'aaa') }

    it 'should be successful' do
      get :edit, params: { id: 'aaa' }
      expect(response).to be_success
    end
  end

  describe 'GET #new' do
    it 'should be successful' do
      get :new
      expect(response).to be_success
    end
  end

  describe 'POST #create' do
    context 'user found' do
      let(:user) { instance_double(User) }
      let(:email) { Faker::Internet.email }

      before do
        allow(User).to receive(:find_by).with(email: email) { user }
      end

      it 'is successful' do
        expect(user).to receive(:send_password_reset)

        post :create, params: { email: email }
        expect(flash[:success]).to be_present
        expect(response).to redirect_to root_url
      end
    end

    context 'user not found' do
      before do
        allow(User).to receive(:find_by_email) { nil }
      end

      it 'sets flash error' do
        post :create, params: { email: Faker::Internet.email }
        expect(response).to render_template :new
        expect(flash[:error]).to be_present
      end
    end
  end

  describe 'PUT #update' do
    context 'password reset sent less than 2 hours ago' do
      let!(:user) { create(:user, password_reset_token: 'aaa', password_reset_sent_at: 1.day.ago) }
      it 'sets alerts' do
        put :update, params: { id: 'aaa', user: { password: 'aaa', password_confirmation: 'aaa' } }
        expect(response).to redirect_to new_password_reset_path
      end
    end

    context 'password reset sent more than 2 hours' do
      let!(:user) { create(:user, password_reset_token: 'aaa', password_reset_sent_at: 1.hour.ago) }
      it 'is successful' do
        put :update, params: { id: 'aaa', user: { password: 'aaaaaaaaa', password_confirmation: 'aaaaaaaaa' } }
        expect(response).to redirect_to root_url
      end
    end
  end
end
