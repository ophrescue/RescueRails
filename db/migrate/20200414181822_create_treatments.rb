class CreateTreatments < ActiveRecord::Migration[5.2]
  def change
    create_table :treatments do |t|
      t.string :name, null: false
      t.string :available_for, null: false
      t.boolean :has_result, null: false, default: false
      t.text :recommendation
      t.timestamps
    end
  end
end
