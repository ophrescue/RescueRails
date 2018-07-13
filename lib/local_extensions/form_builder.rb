class ActionView::Helpers::FormBuilder
  def bootstrap_errors(method, options={})
    message = object.errors.messages[method].first || object.class.client_validation_error_messages_for(method)
    field_name = method.to_s.humanize(keep_id_suffix: true) # e.g. tracking_id -> "Tracking Id"
    klass = "invalid-feedback #{options[:class]}"
    "<div class='#{klass}'>#{field_name} #{message}</div>".html_safe
  end
end
