class CreateFosters < ActiveRecord::Migration[4.2]
  def change
    create_table :fosters do |t|
      t.integer :user_id, null: false
      t.integer :dog_id, null: false
      t.date :start_date, null: false
      t.date :end_date
      t.integer :updated_by, null: false

      t.timestamps
    end
    add_index :fosters, :user_id
    add_index :fosters, :dog_id
    add_index :fosters, [:user_id, :dog_id]
  end
end
