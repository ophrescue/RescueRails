class Breeds < ActiveRecord::Migration
  def change
    create_table :breeds do |t|
      t.string :name 

      t.timestamps
    end
    add_index  :breeds, :name
  end
end
