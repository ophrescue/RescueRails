class AddContractReceivedAtToInvoice < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :contract_received_at, :timestamp
  end
end
