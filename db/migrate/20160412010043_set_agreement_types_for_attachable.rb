class SetAgreementTypesForAttachable < ActiveRecord::Migration
  def up
    Attachment.where(attachable_type: 'User').update_all(agreement_type: 'foster')
  end

  def down
    Attachment.where(attachable_type: 'User').update_all(agreement_type: nil)
  end
end
