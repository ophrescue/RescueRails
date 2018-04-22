class CreateEvents < ActiveRecord::Migration[4.2]
  def change
    create_table :events do |t|
      t.string :title
      t.timestamp :start_ts
      t.timestamp :end_ts
      t.string :location_name
      t.string :address
      t.text :description
      t.integer :created_by_user

      t.timestamps
    end
    add_index :events, :start_ts
  end
end
