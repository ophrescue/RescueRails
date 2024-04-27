class VolunteerAppMailerPreview < ActionMailer::Preview
  def notify_applicant
    @volunteer = VolunteerApp.last
    VolunteerAppMailer.notify_applicant
  end

  def notify_oph
    @volunteer = VolunteerApp.last
    VolunteerAppMailer.notify_oph
  end
end
