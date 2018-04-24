class AddAgreementIDtoUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :agreement_id, :integer
    add_index :users, :agreement_id
  end
end
