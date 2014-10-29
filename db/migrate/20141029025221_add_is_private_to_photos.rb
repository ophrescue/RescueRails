class AddIsPrivateToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :is_private, :boolean, default: false
  end
end
