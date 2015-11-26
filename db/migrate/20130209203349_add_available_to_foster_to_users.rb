class AddAvailableToFosterToUsers < ActiveRecord::Migration
  def change
    add_column :users, :available_to_foster, :boolean, default: false
  end
end
