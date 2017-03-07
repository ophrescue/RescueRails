module Auditable
  extend ActiveSupport::Concern

  included do
    attr_accessor :updated_by_admin_user
    after_update :audit_changes
  end

  def audit_attributes_changed?
    changed_audit_attributes.present?
  end

  def changed_audit_attributes
    changed & attributes_to_audit
  end

  def audit_content
    content = "#{updated_by_admin_user.name} has "
    content + changes_to_sentence
  end

  def changes_to_sentence
    result = []
    changed_audit_attributes.each do |attr|
      old_value = send("#{attr}_was")
      new_value = send(attr)
      result << "changed #{attr} from #{old_value} to #{new_value}"
    end
    result.sort.join(' * ')
  end

  def audit_changes
    return unless audit_attributes_changed?
    return if updated_by_admin_user.blank?

    comment = Comment.new(content: audit_content)
    comment.user = updated_by_admin_user
    comments <<  comment
  end

  def attributes_to_audit
    []
  end
end
