class AddAvailableToFosterToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :available_to_foster, :boolean, default: false
  end
end
