#    Copyright 2017 Operation Paws for Homes
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

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
