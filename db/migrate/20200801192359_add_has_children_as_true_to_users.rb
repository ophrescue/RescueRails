class AddHasChildrenAsTrueToUsers < ActiveRecord::Migration[5.2]
  def change
    query = <<-SQL
     update users
     set has_children = children_under_five
   SQL

   execute query
  end
end
