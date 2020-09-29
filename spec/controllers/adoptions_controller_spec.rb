# == Schema Information
#
# Table name: adoptions
#
#  id            :integer          not null, primary key
#  adopter_id    :integer
#  dog_id        :integer
#  relation_type :string
#  created_at    :datetime
#  updated_at    :datetime
#

require 'rails_helper'

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
      let(:adopter) { create(:adopter, :with_app, status: 'completed', dog_or_cat: 'Dog', adoptions_attributes: [{ relation_type: 'interested' }]) }
      
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
    let(:adopter) { create(:adopter, :with_app, status: 'completed', dog_or_cat: 'Dog', adoptions_attributes: [
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
