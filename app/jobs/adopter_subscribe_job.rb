class AdopterSubscribeJob < ActiveJob::Base
  queue_as :default

  def perform(email, merge_vars, interests)
    MailChimpService.adopter_subscribe(email, merge_vars, interests)
  end
end
