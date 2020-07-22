class AddIsAddressValidToAdopters < ActiveRecord::Migration[5.2]
  def change
    add_column :adopters, :is_address_valid, :boolean, default: true
  end
end
