module ClientValidated
  extend ActiveSupport::Concern

  class_methods do
    # render validation messages on page, css hidden
    # HTML5 validation and Bootstrap css will show the messages as required
    def client_validation_error_messages_for(field)
      key = self::VALIDATION_ERROR_MESSAGES[field] || :blank
      if key.is_a?(Array)
        key, params = key
        I18n.t("errors.messages.#{key}", params)
      else
        I18n.t("errors.messages.#{key}")
      end
    end
  end

end
