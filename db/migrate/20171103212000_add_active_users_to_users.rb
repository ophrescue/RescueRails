class AddActiveUsersToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :active, :boolean, default: false, null: false, comment: 'if false user is a candiate volunteer and should only be able to see and edit their profile'
  end
end
