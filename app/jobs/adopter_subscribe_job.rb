class AdopterSubscribeJob < ActiveJob::Base
  queue_as :default

  def perform(email, merge_vars)
    MailChimpService.adopter_subscribe(email, merge_vars)
  end
end
