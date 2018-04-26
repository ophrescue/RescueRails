class AddBesttimeToReferences < ActiveRecord::Migration[4.2]
  def change
    add_column :references, :whentocall, :string
  end
end
