require 'rails_helper'

describe NewAdopterMailer, type: :mailer do
  include ActiveJob::TestHelper

  describe "Application Received! Email" do
    let(:adopter) { create(:adopter, :with_app, status: 'new') }

    it 'job is created' do
      expect do
        NewAdopterMailer.adopter_created(adopter.id).deliver_later
      end.to have_enqueued_job.on_queue('mailers')
    end

    it 'welcome_email is sent' do
      expect do
        perform_enqueued_jobs do
          NewAdopterMailer.adopter_created(adopter.id).deliver_later
        end
      end.to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    it 'welcome_email is sent to the right user' do
      perform_enqueued_jobs do
        NewAdopterMailer.adopter_created(adopter.id).deliver_later
      end
      mail = ActionMailer::Base.deliveries.last
      expect(mail.to[0]).to eq adopter.email
    end
  end
end
