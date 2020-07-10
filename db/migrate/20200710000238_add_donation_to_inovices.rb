class AddDonationToInovices < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :donation, :integer
  end
end
