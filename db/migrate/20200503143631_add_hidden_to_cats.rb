class AddHiddenToCats < ActiveRecord::Migration[5.2]
  def change
    add_column :cats, :hidden, :boolean, null: false, default: false
  end
end
