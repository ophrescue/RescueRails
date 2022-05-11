class AddFosterFriendToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :foster_friend, :boolean, null: false, default: false
  end
end
