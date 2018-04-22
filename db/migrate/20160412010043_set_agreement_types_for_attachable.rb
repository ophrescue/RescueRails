class SetAgreementTypesForAttachable < ActiveRecord::Migration[4.2]
  def up
    Attachment.where(attachable_type: 'User').update_all(agreement_type: 'foster')
  end

  def down
    Attachment.where(attachable_type: 'User').update_all(agreement_type: nil)
  end
end
