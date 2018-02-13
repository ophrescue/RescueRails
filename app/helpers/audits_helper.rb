module AuditsHelper
  def classify_foreign_key(audit_column, audit_type)
    reflections = audit_type.reflect_on_all_associations(:belongs_to).select { |r| r.foreign_key == audit_column } if audit_type.respond_to?(:reflect_on_all_associations)
    return reflections.first.class_name.safe_constantize if reflections&.any?

    if audit_column =~ /_id$/
      attr = audit_column.sub(/_id$/, '')
      attr = attr.classify.safe_constantize
    else
      attr = nil
    end

    attr.nil? ? audit_column : attr
  end

  def value_from_audit(audit_column, audit_value, audited_model)
    return if audit_value.blank?

    foreign_key = classify_foreign_key(audit_column, audited_model)

    if foreign_key&.class == Class
      foreign_key.find(audit_value).display_name
    else
      foreign_key
    end
  end
end
