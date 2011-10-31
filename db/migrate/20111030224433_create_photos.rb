class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photo do |t|
      t.integer :dog_id
      t.string :dogpic_file_name
      t.string :dogpic_content_type
      t.string :dogpic_file_size
      t.datetime :dogpic_updated_at

      t.timestamps
    end
    add_index :photo, :dog_id
  end
end
