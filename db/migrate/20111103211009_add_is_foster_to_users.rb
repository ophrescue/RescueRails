class AddIsFosterToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :is_foster, :boolean, default: false
  end
end
