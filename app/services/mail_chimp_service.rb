class MailChimpService
  attr_reader :client

  def initialize
    klass = Rails.env.test? ? FakeMailChimpClient : MailChimpClient
    @client = klass.new
  end

  def self.user_subscribe(name, email)
    new.client.user_subscribe(name, email)
  end

  def self.user_unsubscribe(email)
    new.client.user_unsubscribe(email)
  end

  def self.adopter_subscribe(email, merge_vars, interests)
    new.client.adopter_subscribe(email, merge_vars, interests)
  end

  def self.adopter_unsubscribe(email)
    new.client.adopter_unsubscribe(email)
  end
end
