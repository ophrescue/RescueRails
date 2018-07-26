require 'rails_helper'

describe PasswordsController do
  describe "#new" do
    it "renders the password reset form" do
      get :new

      expect(response).to be_success
      expect(response).to render_template(:new)
    end
  end

  describe "#edit" do
    context "valid id and token are supplied in url" do
      it "redirects to the edit page with token now removed from url" do
        user = create(:user, :with_forgotten_password)

        get :edit, params: { user_id: user, token: user.confirmation_token }

        expect(response).to be_redirect
        expect(response).to redirect_to edit_user_password_url(user)
        expect(session[:password_reset_token]).to eq user.confirmation_token
      end
    end

    context "valid id in url and valid token in session" do
      it "renders the password reset form" do
        user = create(:user, :with_forgotten_password)

        request.session[:password_reset_token] = user.confirmation_token
        get :edit, params: { user_id: user }

        expect(response).to be_success
        expect(response).to render_template(:edit)
        expect(assigns(:user)).to eq user
      end
    end

    context "blank token is supplied" do
      it "renders the new password reset form with a flash notice" do
        get :edit, params: { user_id: 1, token: "" }

        expect(response).to render_template(:new)
        expect(flash.now[:notice]).to match(/double check the URL/i)
      end
    end

    context "invalid token is supplied" do
      it "renders the new password reset form with a flash notice" do
        user = create(:user, :with_forgotten_password)

        get :edit, params: { user_id: 1, token: user.confirmation_token + "a" }

        expect(response).to render_template(:new)
        expect(flash.now[:notice]).to match(/double check the URL/i)
      end
    end

    context "old token in session and recent token in params" do
      it "updates password reset session and redirect to edit page" do
        user = create(:user, :with_forgotten_password)
        request.session[:password_reset_token] = user.confirmation_token

        user.forgot_password!
        get :edit, params: { user_id: user.id, token: user.reload.confirmation_token }

        expect(response).to redirect_to(edit_user_password_url(user))
        expect(session[:password_reset_token]).to eq(user.confirmation_token)
      end
    end
  end

  describe "#update" do
    context 'state is missing from user' do
      let(:user) { create(:user, :with_forgotten_password) }

      before do
        user.update_column(:region, nil)
      end

      it "does not update the password" do
        put :update, params: update_parameters(user, new_password: "abcdefghijk")
        old_encrypted_password = user.encrypted_password

        user.reload
        expect(user.encrypted_password).to eq old_encrypted_password
        expect(user.confirmation_token).to be_present
      end
    end
  end

  def update_parameters(user, options = {})
    new_password = options.fetch(:new_password)

    {
      user_id: user,
      token: user.confirmation_token,
      password_reset: { password: new_password }
    }
  end
end
