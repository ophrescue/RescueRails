class AddHiddenToDogs < ActiveRecord::Migration[5.2]
  def change
    add_column :dogs, :hidden, :boolean, null: false, default: false
  end
end
