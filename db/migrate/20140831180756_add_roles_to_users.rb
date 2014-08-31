class AddRolesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_photographer, :boolean
    add_column :users, :writes_newsletter, :boolean
  end
end
