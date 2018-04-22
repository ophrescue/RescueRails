class AddAddDogsToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :add_dogs, :boolean, default: false
  end
end
