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

  describe 'GET index' do
    include_context 'signed in admin'

    it 'should be successful' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET show' do
    include_context 'signed in admin'

    let(:adopter) { create(:adopter_with_app, status: 'approved') }

    it 'should be successful' do
      get :show, params: { id: adopter.id }
      expect(response).to be_successful
    end
  end

  describe 'GET new' do
    it 'should be successful' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'POST create' do
    let(:adoption_app) { attributes_for(:adoption_app) }
    let(:adopter) { attributes_for(:adopter, adoption_app_attributes: adoption_app) }

    it 'creates an adopter' do
      post :create, params: { adopter: adopter }

      expect(response).to redirect_to root_path(adoptapp: 'complete')
    end
  end

  describe 'PUT update' do
    include_context 'signed in admin'

    let(:adopter) { create(:adopter_with_app, status: 'approved') }

    context 'can complete adopters' do
      before do
        allow(controller).to receive(:can_complete_adopters?) { true }
      end

      it 'should be successful' do
        put :update, params: { id: adopter.id, adopter: { status: 'completed' } }
        expect(flash[:success]).to be
        expect(response).to redirect_to adopter_url(adopter)
      end
    end

    context 'cannot complete adopters' do
      include_context 'signed in admin'

      before do
        allow(controller).to receive(:can_complete_adopters?) { false }
      end

      it 'sets flash error' do
        put :update, params: { id: adopter.id, adopter: { status: 'completed' } }
        expect(flash[:error]).to be
      end
    end
  end

  describe 'Adopter recept of Training Coupon' do
    include ActiveJob::TestHelper
    include_context 'signed in admin'

    context 'adopter set to adopted status for the first time' do
      let(:adopter) { create(:adopter_with_app, status: 'approved') }

      it 'free training coupon email created' do
        ActiveJob::Base.queue_adapter = :test
        expect do
          put :update, params: { id: adopter.id, adopter: { status: 'adopted' } }
        end.to have_enqueued_job.on_queue('mailers')
      end

      it 'free training coupon is sent' do
        expect do
          perform_enqueued_jobs do
            put :update, params: { id: adopter.id, adopter: { status: 'adopted' } }
          end
        end.to change { ActionMailer::Base.deliveries.size }.by(1)
      end

      it 'free training coupon is set to the right user' do
        perform_enqueued_jobs do
          put :update, params: { id: adopter.id, adopter: { status: 'adopted' } }
        end

        mail = ActionMailer::Base.deliveries.last
        expect(mail.to[0]).to eq adopter.email
      end

      it 'training_email_sent is set to true' do
        put :update, params: { id: adopter.id, adopter: { status: 'adopted' } }
        expect(adopter.reload.training_email_sent).to eq true
      end
    end

    context 'adopter has already been sent training email' do
      let(:adopter) { create(:adopter_with_app, status: 'approved', training_email_sent: true) }

      it 'free training coupon is not sent' do
        expect do
          perform_enqueued_jobs do
            put :update, params: { id: adopter.id, adopter: { status: 'adopted' } }
          end
        end.to change { ActionMailer::Base.deliveries.size }.by(0)
      end
    end
  end

  describe 'GET check_email' do
    subject(:check_email) { get :check_email, xhr: true, params: { adopter: { email: adopter.email } } }

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
