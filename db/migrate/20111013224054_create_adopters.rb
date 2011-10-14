class CreateAdopters < ActiveRecord::Migration
  def change
    create_table :adopters do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.string :status
      t.string :when_to_call

      t.timestamps
    end
  end
end
