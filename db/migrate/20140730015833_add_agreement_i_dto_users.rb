class AddAgreementIDtoUsers < ActiveRecord::Migration
  def change
    add_column :users, :agreement_id, :integer
    add_index :users, :agreement_id
  end
end
