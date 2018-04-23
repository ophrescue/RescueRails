require 'rails_helper'

describe TrainingMailer, type: :mailer do
  include ActiveJob::TestHelper

  describe "Training Coupon Email" do
    let(:adopter) { create(:adopter_with_app) }

    it 'job is created' do
      ActiveJob::Base.queue_adapter = :test
      expect do
        TrainingMailer.free_training_notice(adopter.id).deliver_later
      end.to have_enqueued_job.on_queue('mailers')
    end

    it 'welcome_email is sent' do
      expect do
        perform_enqueued_jobs do
          TrainingMailer.free_training_notice(adopter.id).deliver_later
        end
      end.to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    it 'welcome_email is sent to the right user' do
      perform_enqueued_jobs do
        TrainingMailer.free_training_notice(adopter.id).deliver_later
      end
      mail = ActionMailer::Base.deliveries.last
      expect(mail.to[0]).to eq adopter.email
    end
  end
end
