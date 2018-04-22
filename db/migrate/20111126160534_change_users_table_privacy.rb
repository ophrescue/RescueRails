class ChangeUsersTablePrivacy < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :share_info
    add_column :users, :share_info, :text
  end
end
