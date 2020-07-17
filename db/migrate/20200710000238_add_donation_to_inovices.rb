class AddDonationToInovices < ActiveRecord::Migration[5.2]
  def change
    add_reference :invoices, :donation, foreign_key: true, optional: true
    add_column :invoices, :has_donation, :boolean, null: false, default: false
  end
end
