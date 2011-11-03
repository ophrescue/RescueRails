class AddIsFosterToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_foster, :boolean, :default => false
  end
end
