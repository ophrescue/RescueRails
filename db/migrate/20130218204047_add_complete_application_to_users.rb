class AddCompleteApplicationToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :complete_adopters, :boolean, default: false
  end
end
