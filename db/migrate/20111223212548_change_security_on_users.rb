class ChangeSecurityOnUsers < ActiveRecord::Migration
  def change
	remove_column :users, :edit_adopters
	remove_column :users, :view_adopters
	add_column :users, :edit_my_adopters, :boolean, default: false
	add_column :users, :edit_all_adopters, :boolean, default: false
	add_column :users, :locked, :boolean, default: false
	add_column :users, :edit_events, :boolean, default: false
  end
end
