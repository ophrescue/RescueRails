class AddRolesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_photographer, :boolean, :default => false
    add_column :users, :writes_newsletter, :boolean, :default => false
  end
end
