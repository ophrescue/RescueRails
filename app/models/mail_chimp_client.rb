class MailChimpClient
  attr_reader :gibbon

  USER_LIST_ID = 'aa86c27ddd'.freeze
  ADOPTER_LIST_ID = '5e50e2be93'.freeze

  def initialize
    @gibbon = Gibbon::API.new
    @gibbon.timeout = 30
  end

  def user_subscribe(name, email)
    merge_vars = {
      'FNAME' => name
    }

    gibbon.lists.subscribe(
      id: USER_LIST_ID,
      email: { email: email },
      merge_vars: merge_vars,
      double_optin: true,
      send_welcome: false
    )
  end

  def user_unsubscribe(email)
    gibbon.throws_exceptions = false

    gibbon.lists.unsubscribe({
      id: USER_LIST_ID,
      email: {email: email},
      delete_member: true,
      send_goodbye: false,
      send_notify: false
    })
  end

  def adopter_subscribe(email, is_subscribed, merge_vars)
    list_data = {
      id: ADOPTER_LIST_ID,
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
      id: ADOPTER_LIST_ID,
      email: { email: email },
      delete_member: true,
      send_goodbye: false,
      send_notify: false
    )

    gibbon.throws_exceptions = true
  end
end
