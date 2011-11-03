class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.integer :dog_id
      t.integer :user_id
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
