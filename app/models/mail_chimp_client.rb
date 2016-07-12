class MailChimpClient
  attr_reader :gibbon

  def initialize
    @gibbon = Gibbon::API.new
    @gibbon.timeout = 30
  end

  def user_subscribe(name, email)
    merge_vars = {
      'FNAME' => name
    }

    gibbon.lists.subscribe(
      id: user_list_id,
      email: { email: email },
      merge_vars: merge_vars,
      double_optin: true,
      send_welcome: false
    )
  end

  def user_unsubscribe(email)
    gibbon.throws_exceptions = false

    gibbon.lists.unsubscribe(
      id: user_list_id,
      email: { email: email },
      delete_member: true,
      send_goodbye: false,
      send_notify: false
    )
  end

  def adopter_subscribe(email, is_subscribed, merge_vars)
    list_data = {
      id: adopter_list_id,
      email: { email: email },
      merge_vars: merge_vars,
      double_optin: true,
      send_welcome: false
    }

    if is_subscribed
      gibbon.lists.update_member(list_data)
    else
      gibbon.lists.subscribe(list_data)
    end
  end

  def adopter_unsubscribe(email)
    gibbon.throws_exceptions = false

    gibbon.lists.unsubscribe(
      id: adopter_list_id,
      email: { email: email },
      delete_member: true,
      send_goodbye: false,
      send_notify: false
    )

    gibbon.throws_exceptions = true
  end

  private

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
