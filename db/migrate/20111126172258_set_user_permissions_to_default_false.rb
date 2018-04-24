class SetUserPermissionsToDefaultFalse < ActiveRecord::Migration[4.2]
  def change
    change_column :users, :edit_adopters, :boolean, default: false
    change_column :users, :edit_dogs, :boolean, default: false
    change_column :users, :view_adopters, :boolean, default: false
  end
end
