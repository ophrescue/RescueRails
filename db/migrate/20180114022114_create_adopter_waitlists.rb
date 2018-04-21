class CreateAdopterWaitlists < ActiveRecord::Migration[5.0]
  def change
    create_table :adopter_waitlists do |t|
      t.integer :rank

      t.timestamps
    end
  end
end
