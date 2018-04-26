class AddSecondphonenumberToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :other_phone, :string
  end
end
