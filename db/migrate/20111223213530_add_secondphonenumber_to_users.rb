class AddSecondphonenumberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :other_phone, :string
  end
end
