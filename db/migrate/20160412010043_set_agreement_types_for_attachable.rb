class SetAgreementTypesForAttachable < ActiveRecord::Migration
  def up
    execute "UPDATE attachments SET agreement_type = 'foster' WHERE attachable_type = 'User';"
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
