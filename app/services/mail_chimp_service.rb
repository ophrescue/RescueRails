class MailChimpService
  attr_reader :client

  def initialize
    klass = Rails.env.test? ? FakeMailChimpClient : MailChimpClient
    @client = klass.new
  end

  def self.subscribe(name, email)
    new.client.subscribe(name, email)
  end

  def self.unsubscribe(name, email)
    new.client.unsubscribe(name, email)
  end

  def self.adopter_subscribe(email, is_subscribed, merge_vars)
    new.client.adopter_subscribe(email, is_subscribed, merge_vars)
  end

  def self.adopter_unsubscribe(email)
    new.client.adopter_unsubscribe(email)
  end
end
