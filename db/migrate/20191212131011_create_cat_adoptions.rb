class CreateCatAdoptions < ActiveRecord::Migration[5.2]
  def change
    create_table :cat_adoptions do |t|
      t.integer :adopter_id
      t.integer :cat_id
      t.string :relation_type
      t.timestamps
    end
    add_index :cat_adoptions, :adopter_id
    add_index :cat_adoptions, :cat_id
    add_index :cat_adoptions, [:adopter_id, :cat_id], unique: true
  end
end
