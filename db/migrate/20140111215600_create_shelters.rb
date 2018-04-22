class CreateShelters < ActiveRecord::Migration[4.2]
  def change
    create_table :shelters do |t|
      t.string :name

      t.timestamps
    end
  end
end
