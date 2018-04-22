class AddTransportToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :is_transporter, :boolean, default: false
  end
end
