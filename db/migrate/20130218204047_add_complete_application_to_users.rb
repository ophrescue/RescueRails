class AddCompleteApplicationToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :complete_adopters, :boolean, default: false
  end
end
