class CreateConnections < ActiveRecord::Migration[4.2]
  def change
    create_table :connections do |t|
      t.integer :adopter_id
      t.integer :dog_id
      t.string :type

      t.timestamps
    end

    add_index :connections, :adopter_id
    add_index :connections, :dog_id
    add_index :connections, [:adopter_id, :dog_id], unique: true

  end
end
