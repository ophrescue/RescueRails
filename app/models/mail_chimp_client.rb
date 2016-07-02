class MailChimpClient
  attr_reader :gibbon

#TODO These should probably get moved to ENV Variables?
  USER_LIST_ID = 'aa86c27ddd'.freeze
  ADOPTER_LIST_ID = '5e50e2be93'.freeze

  INTEREST_SUPPORTER = 'f64cb9ee99'.freeze
  INTEREST_ACTIVE_APPLICATION = 'f188dcc7d6'.freeze
  INTEREST_ADOPTED_FROM_OPH = '38e640c912'.freeze

  def initialize
    @gibbon = Gibbon::Request.new
    @gibbon.timeout = 30
  end

  def subscribe(list_id, email, merge_vars)
    gibbon.lists(list_id).members(hashed(email)).upsert(
      body: {
        email_address: email,
        status: 'pending',
        merge_fields: merge_vars
  #TODO      interests: {
  #TODO        INTEREST_SUPPORTER: true/false
  #TODO        INTEREST_ACTIVE_APPLICATION: true/false
  #TODO        INTEREST_ADOPTED_FROM_OPH: true/false
        }
      }
    )
  end

  def unsubscribe(list_id, email)
    gibbon.lists(list_id).members(hashed(email)).update(body: { status: "unsubscribed" })
  end

  def user_subscribe(name, email)
    merge_vars = {
      'FNAME' => name
    }

    subscribe(USER_LIST_ID, email, merge_vars)
  end

  def user_unsubscribe(email)
    unsubscribe(USER_LIST_ID, email)
  end

  def adopter_subscribe(email, merge_vars)
    subscribe(ADOPTER_LIST_ID, email, merge_vars)
  end

  def adopter_unsubscribe(email)
    unsubscribe(ADOPTER_LIST_ID, email)
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
