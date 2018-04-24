class CreateHistories < ActiveRecord::Migration[4.2]
  def change
    create_table :histories do |t|
      t.integer :dog_id
      t.integer :user_id
      t.date :foster_start_date
      t.date :foster_end_date

      t.timestamps
    end
  end
end
