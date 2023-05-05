require 'rails_helper'

describe VolunteerAppMailer, type: :mailer do
  include ActiveJob::TestHelper

  describe "Notify Applicant and OPH" do
    let(:volunteer_app) { create(:volunteer_app, status: 'new') }

    it 'job is created' do
      expect do
        VolunteerAppMailer.with(volunteer_app: volunteer_app).notify_applicant.deliver_later
      end.to have_enqueued_job.on_queue('mailers')
    end

    it 'welcome_email is sent' do
      expect do
        perform_enqueued_jobs do
            VolunteerAppMailer.with(volunteer_app: volunteer_app).notify_applicant.deliver_later
        end
      end.to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    it 'welcome_email is sent to the right user' do
      perform_enqueued_jobs do
        VolunteerAppMailer.with(volunteer_app: volunteer_app).notify_applicant.deliver_later
      end
      mail = ActionMailer::Base.deliveries.last
      expect(mail.to[0]).to eq volunteer_app.email
    end
  end

  describe "Notify OPH of Foster Application" do
    let(:volunteer_app) { create(:volunteer_app, status: 'new', fostering_interest: true) }

    it 'job is created' do
      expect do
        VolunteerAppMailer.with(volunteer_app: volunteer_app).notify_oph.deliver_later
      end.to have_enqueued_job.on_queue('mailers')
    end

    it 'welcome_email is sent' do
      expect do
        perform_enqueued_jobs do
          VolunteerAppMailer.with(volunteer_app: volunteer_app).notify_oph.deliver_later
        end
      end.to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    it 'welcome_email is sent to the right user' do
      perform_enqueued_jobs do
        VolunteerAppMailer.with(volunteer_app: volunteer_app).notify_oph.deliver_later
      end
      mail = ActionMailer::Base.deliveries.last
      expect(mail.to[0]).to include "jamie@ophrescue.org"
    end
  end

  describe "Notify OPH of Foster Application" do
    let(:volunteer_app) { create(:volunteer_app, status: 'new', marketing_interest: true) }

    it 'job is created' do
      expect do
        VolunteerAppMailer.with(volunteer_app: volunteer_app).notify_oph.deliver_later
      end.to have_enqueued_job.on_queue('mailers')
    end

    it 'welcome_email is sent' do
      expect do
        perform_enqueued_jobs do
            VolunteerAppMailer.with(volunteer_app: volunteer_app).notify_oph.deliver_later
        end
      end.to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    it 'welcome_email is sent to the right user' do
      perform_enqueued_jobs do
        VolunteerAppMailer.with(volunteer_app: volunteer_app).notify_oph.deliver_later
      end
      mail = ActionMailer::Base.deliveries.last
      expect(mail.to[0]).to include "volunteer@ophrescue.org"
    end
  end
end
