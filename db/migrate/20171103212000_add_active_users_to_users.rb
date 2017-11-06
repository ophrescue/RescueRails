class AddActiveUsersToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :active, :boolean, default: false, null: false
  end
end
