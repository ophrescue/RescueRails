class AddHasKidsFosterDataToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :has_children, :boolean, default: false
  end
end
