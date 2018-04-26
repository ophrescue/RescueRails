class AddFeeToDogs < ActiveRecord::Migration[4.2]
  def change
    add_column :dogs, :fee, :integer
  end
end
