class AddLastVerifiedtoUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :lastverified, :timestamp
  end

end
