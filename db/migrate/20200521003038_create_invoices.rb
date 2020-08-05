class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.integer :invoiceable_id
      t.string :invoiceable_type
      t.string :slug
      t.integer :amount
      t.string :status
      t.belongs_to :user, foreign_key: true
      t.text :description
      t.string :stripe_customer_id
      t.string :card_token
      t.datetime :paid_at
      t.string :paid_method
      t.timestamps
    end
    add_index :invoices, :slug, unique: true
  end
end
