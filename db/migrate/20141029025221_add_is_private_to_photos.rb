class AddIsPrivateToPhotos < ActiveRecord::Migration[4.2]
  def change
    add_column :photos, :is_private, :boolean, default: false
  end
end
