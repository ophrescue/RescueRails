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

    let(:adopter) { create(:adopter, :with_app, status: 'approved') }

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
    let(:adopter) { create(:adopter, :with_app, status: 'approved') }

    include_context 'signed in admin'

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
      before do
        allow(controller).to receive(:can_complete_adopters?) { false }
      end

      it 'sets flash error' do
        put :update, params: { id: adopter.id, adopter: { status: 'completed' } }
        expect(flash[:error]).to be
      end
    end

    context 'cannot update with invalid email' do
      let(:request) { -> { put :update, params: { id: adopter.id, adopter: attributes_for(:adopter, email: 'joe@test.com, jane@test.com') } } }

      it 'does not update' do
        expect { request.call }.to_not change { adopter.reload.email }
      end
    end
  end

  describe 'Adopter receipt of Training Coupon and followup email' do
    include ActiveJob::TestHelper
    include_context 'signed in admin'

    context 'cat adopter test training email' do
      let(:adopter) { create(:adopter, :with_app, status: 'adopted', dog_or_cat: 'Cat', adoptions_attributes: [{ relation_type: 'interested' }]) }
      
      it 'cat adopter does not create training email' do
        ActiveJob::Base.queue_adapter = :test
        expect do 
          adopter.update_attributes(adoptions_attributes: [{ id: adopter.adoptions.first.id, relation_type: 'adopted' }])
        end.not_to have_enqueued_job.with("TrainingMailer","free_training_notice","deliver_now", adopter.id)
      end
    end
 
    context 'adoption set to adopted relation_type for the first time' do
      let(:adopter) { create(:adopter, :with_app, status: 'adopted', dog_or_cat: 'Dog', adoptions_attributes: [{ relation_type: 'interested' }]) }
      
      it 'free training coupon email created' do
        ActiveJob::Base.queue_adapter = :test
        expect do
          adopter.update_attributes(adoptions_attributes: [{ id: adopter.adoptions.first.id, relation_type: 'adopted' }])
        end.to have_enqueued_job.with("TrainingMailer","free_training_notice","deliver_now", adopter.id)
      end

      it 'one week followup email created' do
        ActiveJob::Base.queue_adapter = :test
        expect do
          adopter.update_attributes(adoptions_attributes: [{ id: adopter.adoptions.first.id, relation_type: 'adopted' }])
        end.to have_enqueued_job.with("AdopterFollowupMailer","one_week_followup","deliver_now", adopter.id)
      end

      it 'free training coupon and one week followup is sent' do
        expect do
          perform_enqueued_jobs do
            adopter.update_attributes(adoptions_attributes: [{ id: adopter.adoptions.first.id, relation_type: 'adopted' }])
          end
        end.to change { ActionMailer::Base.deliveries.size }.by(2)
      end

      it 'free training coupon and one week followup is set to the right adopter' do
        perform_enqueued_jobs do
          adopter.update_attributes(adoptions_attributes: [{ id: adopter.adoptions.first.id, relation_type: 'adopted' }])
        end
        mail = ActionMailer::Base.deliveries.last
        expect(mail.to[0]).to eq adopter.email
      end
    end

  context 'three adoptions, three training emails'
    let(:adopter) { create(:adopter, :with_app, status: 'adopted', dog_or_cat: 'Dog', adoptions_attributes: [
      { relation_type: 'interested' }, { relation_type: 'interested' }, { relation_type: 'interested' }]) }

    it 'sends three training coupon emails and three followup emails' do
      expect do
        perform_enqueued_jobs do
          adopter.update_attributes(adoptions_attributes: [{ id: adopter.adoptions.first.id, relation_type: 'adopted' }])
          adopter.update_attributes(adoptions_attributes: [{ id: adopter.adoptions[1].id, relation_type: 'adopted' }])
          adopter.update_attributes(adoptions_attributes: [{ id: adopter.adoptions[2].id, relation_type: 'adopted' }])
        end
      end.to change { ActionMailer::Base.deliveries.size }.by(6)
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
