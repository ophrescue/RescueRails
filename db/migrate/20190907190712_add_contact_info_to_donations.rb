class AddContactInfoToDonations < ActiveRecord::Migration[5.2]
  def change
    add_column :donations, :more_contact_info, :boolean, default: false
    add_column :donations, :phone, :string, null: true
    add_column :donations, :address1, :string, null: true
    add_column :donations, :address2, :string, null: true
    add_column :donations, :city, :string, null: true
    add_column :donations, :region, :string, limit: 2, null: true
    add_column :donations, :postal_code, :string, null: true
  end
end
