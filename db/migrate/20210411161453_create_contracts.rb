class CreateContracts < ActiveRecord::Migration[6.0]
  def change
    create_table :contracts do |t|
      t.string :contractable_type
      t.integer :contractable_id
      t.string :esig_contract_id
      t.timestamps
    end
  end
end
