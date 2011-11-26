class ChangeUsersTablePrivacy < ActiveRecord::Migration
  def change
  	remove_column :users, :share_info
  	add_column :users, :share_info, :text
  end
end
