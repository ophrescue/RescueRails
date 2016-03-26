class AddConfidentialityAgreementToUsers < ActiveRecord::Migration
  def change
    add_column :users, :confidentiality_agreement_id, :integer
  end
end
