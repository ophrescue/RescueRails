class AddHasKidsFosterDataToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :has_children, :boolean, default: false, null: false
    query = <<-SQL
     update users
     set has_children = children_under_five
   SQL

   execute query
  end
end
