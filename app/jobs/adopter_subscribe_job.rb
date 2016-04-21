class AdopterSubscribeJob < ActiveJob::Base
  queue_as :default

  def perform(email, is_subscribed, merge_vars)
    MailChimpService.adopter_subscribe(email, is_subscribed, merge_vars)
  end
end
