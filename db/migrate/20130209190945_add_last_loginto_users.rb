class AddLastLogintoUsers < ActiveRecord::Migration
  def change		
  	add_column :users, :lastlogin, :timestamp
  end

end
