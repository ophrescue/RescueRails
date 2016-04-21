class AdopterUnsubscribeJob < ActiveJob::Base
  queue_as :default

  def perform(email)
    MailChimpService.adopter_unsubscribe(email)
  end
end
