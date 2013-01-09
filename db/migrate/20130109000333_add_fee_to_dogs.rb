class AddFeeToDogs < ActiveRecord::Migration
  def change
    add_column :dogs, :fee, :integer
  end
end
