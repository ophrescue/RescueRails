class CreateFolders < ActiveRecord::Migration[4.2]
  def change
    create_table :folders do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
