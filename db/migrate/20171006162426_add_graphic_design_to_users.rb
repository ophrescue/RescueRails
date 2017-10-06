class AddGraphicDesignToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :graphic_design, :boolean, default: false, null:false
  end
end
