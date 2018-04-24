class CreateReferences < ActiveRecord::Migration[4.2]
  def change
    create_table :references do |t|
      t.integer :adopter_id
      t.string :name
      t.string :email
      t.string :phone
      t.string :relationship

      t.timestamps
    end
    add_index :references, :adopter_id
  end
end
