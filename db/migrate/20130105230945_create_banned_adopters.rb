class CreateBannedAdopters < ActiveRecord::Migration[4.2]
  def change
    create_table :banned_adopters do |t|
      t.string :name,  limit: 100
      t.string :phone, limit: 20
      t.string :email, limit: 100
      t.string :city,  limit: 100
      t.string :state, limit: 2
      t.text :comment
      t.timestamps
    end
    add_index :banned_adopters, :name
  end
end
