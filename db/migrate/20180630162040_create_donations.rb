class CreateDonations < ActiveRecord::Migration[5.2]
  def change
    create_table :donations do |t|
      t.string :name
      t.string :email
      t.integer :amount
      t.string :zip
      t.string :card_token
      t.text :comment
      t.timestamps
    end
  end
end
