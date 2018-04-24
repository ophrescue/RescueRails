class AddConfidentialityAgreementToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :confidentiality_agreement_id, :integer
  end
end
