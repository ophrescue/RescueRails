module ValidationHelper
  def validation_class_for(f,field)
    'is-invalid' if f.object.errors.messages[field].any?
  end

  def validation_error_message_for(f,field)
    # only uniqueness validation errors are determined on the server
    # all other errors are determined on the client
    message = f.object.errors.messages[field].first || client_validation_error_messages_for(f,field)
    "#{field.to_s.humanize(keep_id_suffix: true)} #{message}"
  end

  private
  def client_validation_error_messages_for(f,field)
    f.object.class.client_validation_error_messages_for(field)
  end

end
