class UserUnsubscribeJob < ApplicationJob
  queue_as :default

  def perform(email)
    MailChimpService.user_unsubscribe(email)
  end
end
