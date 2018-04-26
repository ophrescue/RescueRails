class AddRestrictedFolderToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :dl_locked_resources, :boolean, default: false
    add_column :folders, :locked, :boolean, default: false
  end
end
