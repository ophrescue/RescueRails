class UserSubscribeJob < ActiveJob::Base
  attr_reader :client
  queue_as :default

  def perform(name, email)
    klass = Rails.env.test? ? FakeMailChimpClient : MailChimpClient
    @client = klass.new
    new.client.user_subscribe(name, email)
  end
end
