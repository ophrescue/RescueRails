class AddAgreementTypeToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :agreement_type, :string
  end
end
