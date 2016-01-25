class AddRestrictedFolderToUsers < ActiveRecord::Migration
  def change
    add_column :users, :dl_locked_resources, :boolean, default: false
    add_column :folders, :locked, :boolean, default: false
  end
end
