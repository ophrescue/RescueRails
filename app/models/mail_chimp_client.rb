class MailChimpClient
  attr_reader :gibbon

  def initialize
    @gibbon = Gibbon::Request.new(debug: true)
    @gibbon.timeout = 30
  end

  def subscribe(list_id, email, merge_vars, interests)
    gibbon.lists(list_id).members(hashed(email)).upsert(
      body: {
        email_address: email,
        status: 'pending',
        merge_fields: merge_vars,
        interests: {
          "#{INTEREST_ACTIVE_APPLICATION}": interests[:active_application],
          "#{INTEREST_ADOPTED_FROM_OPH}": interests[:adopted_from_oph]
        }
      }
    )
  end

  def unsubscribe(list_id, email)
    gibbon
      .lists(list_id)
      .members(hashed(email))
      .update(body: { status: 'unsubscribed' })
  end

  def user_subscribe(name, email)
    merge_vars = {
      'FNAME' => name
    }
    interests = nil

    subscribe(user_list_id, email, merge_vars, interests)
  end

  def user_unsubscribe(email)
    unsubscribe(user_list_id, email)
  end

  def adopter_subscribe(email, merge_vars, interests)
    subscribe(adopter_list_id, email, merge_vars, interests)
  end

  def adopter_unsubscribe(email)
    unsubscribe(adopter_list_id, email)
  end

  private

  def hashed(email)
    Digest::MD5.hexdigest(email.downcase)
  end

  def config(key)
    Rails.application.config_for(:mailchimp)
         .with_indifferent_access[key]
  end

  def user_list_id
    config(:user_list_id)
  end

  def adopter_list_id
    config(:adopter_list_id)
  end
end
