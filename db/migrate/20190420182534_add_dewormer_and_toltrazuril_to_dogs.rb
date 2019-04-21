class AddDewormerAndToltrazurilToDogs < ActiveRecord::Migration[5.2]
  def change
    add_column :dogs, :dewormer, :string
    add_column :dogs, :toltrazuril, :string
  end
end
