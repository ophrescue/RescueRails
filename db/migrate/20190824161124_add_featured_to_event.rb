class AddFeaturedToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :featured, :boolean, null: false, default: false
  end
end
