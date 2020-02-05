class AddPhotoTypeToPhotos < ActiveRecord::Migration[5.2]
  def up
    add_reference :photos, :animal, polymorphic: true
    execute "UPDATE photos SET animal_id = dog_id, animal_type = 'Dog' where animal_id is null and dog_id is not null;"
  end
  def down
    remove_reference :photos, :animal, polymorphic: true
  end
end
