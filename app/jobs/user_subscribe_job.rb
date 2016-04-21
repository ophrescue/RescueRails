class UserSubscribeJob < ActiveJob::Base
  queue_as :default

  def perform(name, email)
    MailChimpService.user_subscribe(name, email)
  end
end
