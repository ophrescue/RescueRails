class AddAddDogsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :add_dogs, :boolean, :default => false
  end
end
