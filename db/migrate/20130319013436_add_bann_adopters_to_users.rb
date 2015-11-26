class AddBannAdoptersToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :ban_adopters, :boolean, default: false
  end
end
