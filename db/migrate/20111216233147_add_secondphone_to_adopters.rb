class AddSecondphoneToAdopters < ActiveRecord::Migration
  def change
    add_column :adopters, :other_phone, :string
  end
end
