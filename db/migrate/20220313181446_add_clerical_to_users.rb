class AddClericalToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :is_clerical, :boolean, null: false, default: false
  end
end
