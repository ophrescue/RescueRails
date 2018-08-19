class CreateDonations < ActiveRecord::Migration[5.2]
  def change
    create_table :donations do |t|
      t.string :stripe_customer_id
      t.string :name
      t.string :email
      t.integer :amount
      t.string :frequency
      t.string :card_token
      t.boolean :notify_someone
      t.string :notify_name
      t.string :notify_email
      t.string :notify_message
      t.boolean :is_memory_honor
      t.string :memory_honor_type
      t.string :memory_honor_name
      t.timestamps
    end
  end
end
