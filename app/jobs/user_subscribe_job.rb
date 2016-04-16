class UserSubscribeJob < ActiveJob::Base
  queue_as :default

  def perform(name, email)
    klass = Rails.env.test? ? FakeMailChimpClient : MailChimpClient
    klass.user_subscribe(name, email)
  end
end
