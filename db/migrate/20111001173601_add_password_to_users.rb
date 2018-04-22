class AddPasswordToUsers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :encrypted_password, :string
  end

  def self.down
    remove_column :users, :encrypted_password
  end
end
