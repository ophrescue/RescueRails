class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.integer :invoiceable_id
      t.string :invoiceable_type
      t.string :url_hash
      t.integer :due_amt
      t.belongs_to :user, foreign_key: true
      t.text :description
      t.string :stripe_customer_id
      t.string :card_token
      t.integer :paid_amt
      t.datetime :paid_at
      t.string :paid_method
      t.timestamps
    end
  end
end
