class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :dog_id
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.datetime :photo_updated_at

      t.timestamps
    end
    add_index :photos, :dog_id
  end
end
