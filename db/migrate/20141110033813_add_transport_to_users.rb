class AddTransportToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_transporter, :boolean, default: false
  end
end
