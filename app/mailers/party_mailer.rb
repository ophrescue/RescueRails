class PartyMailer < ActionMailer::Base
  default from: 'Operation Paws for Homes <noreply@ophrescue.org>'

  def notify(name, email, phone, organization, event_date_and_time, event_location, event_description, guest_count, event_details)

    @name = name
    @email = email
    @phone = phone
    @organization = organization
    @event_date_and_time = event_date_and_time
    @event_location = event_location
    @event_description = event_description
    @guest_count = guest_count
    @event_details = event_details

    mail(
      to: 'puptasticparties@ophrescue.org',
      subject: "Pup-Tastic Party Request",
      content_type: 'text/html'
    ) do |format|
      format.mjml
    end
  end
end
