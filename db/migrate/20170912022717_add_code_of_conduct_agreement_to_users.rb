class AddCodeOfConductAgreementToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :code_of_conduct_agreement_id, :integer
  end
end
