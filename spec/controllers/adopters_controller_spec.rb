require 'spec_helper'

describe AdoptersController, type: :controller do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      expect(response).to be_success
    end
  end

    describe "POST 'create'" do

      context 'success' do
        let(:adoption_app) { attributes_for(:adoption_app) }
        let(:adopter) { attributes_for(:adopter, adoption_app_attributes: adoption_app) }
        subject(:create) { post :create, adopter: adopter }

        it 'create an adopter' do
          expect{ create }.to change{ Adopter.count }.by(1)
        end
      end

  end

  describe 'GET check_email' do
    subject(:check_email) { xhr :get, :check_email, adopter: { email: adopter.email} }

    context 'email exists' do
      let!(:adopter) { create(:adopter) }

      it 'returns false' do
        check_email
        expect(response.body).to eq('false')
      end
    end

    context 'email does not exist' do
      let(:adopter) { build(:adopter) }

      it 'returns true' do
        check_email
        expect(response.body).to eq('true')
      end
    end
  end
end
