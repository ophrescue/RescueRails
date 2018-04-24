class AddPositionToPhotos < ActiveRecord::Migration[4.2]
  def change
    add_column :photos, :position, :integer
  end
end
