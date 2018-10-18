class ActionView::Helpers::FormBuilder
  def bootstrap_errors(method, options={})
    klass = "invalid-feedback #{options.delete(:class)}"
    message = object.errors.messages[method].first || object.class.client_validation_error_messages_for(method)
    field_name = method.to_s.humanize(keep_id_suffix: true) # e.g. tracking_id -> "Tracking Id"
    "<div class='#{klass}'>#{field_name} #{message}</div>".html_safe
  end
end
