class CreateCatPhotos < ActiveRecord::Migration[5.2]
  def change
    create_table :cat_photos do |t|
      t.integer :cat_id
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.datetime :photo_updated_at
      t.timestamps
    end
    add_index :cat_photos, :cat_id
  end
end
