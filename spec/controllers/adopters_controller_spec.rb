# == Schema Information
#
# Table name: adopters
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  email               :string(255)
#  phone               :string(255)
#  address1            :string(255)
#  address2            :string(255)
#  city                :string(255)
#  state               :string(255)
#  zip                 :string(255)
#  status              :string(255)
#  when_to_call        :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  dog_reqs            :text
#  why_adopt           :text
#  dog_name            :string(255)
#  other_phone         :string(255)
#  assigned_to_user_id :integer
#  flag                :string(255)
#  is_subscribed       :boolean          default(FALSE)
#  completed_date      :date
#

require 'rails_helper'

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
