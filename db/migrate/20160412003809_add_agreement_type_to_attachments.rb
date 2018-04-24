class AddAgreementTypeToAttachments < ActiveRecord::Migration[4.2]
  def change
    add_column :attachments, :agreement_type, :string
  end
end
