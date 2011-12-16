class AddBesttimeToReferences < ActiveRecord::Migration
  def change
  	add_column :references, :whentocall, :string
  end
end
