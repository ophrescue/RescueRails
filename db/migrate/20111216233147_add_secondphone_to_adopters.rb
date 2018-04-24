class AddSecondphoneToAdopters < ActiveRecord::Migration[4.2]
  def change
    add_column :adopters, :other_phone, :string
  end
end
