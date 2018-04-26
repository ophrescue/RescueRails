class Breeds < ActiveRecord::Migration[4.2]
  def change
    create_table :breeds do |t|
      t.string :name

      t.timestamps
    end
    add_index  :breeds, :name
  end
end
