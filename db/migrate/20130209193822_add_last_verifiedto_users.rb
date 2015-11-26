class AddLastVerifiedtoUsers < ActiveRecord::Migration
  def change
    add_column :users, :lastverified, :timestamp
  end

end
