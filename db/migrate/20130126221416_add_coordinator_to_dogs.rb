class AddCoordinatorToDogs < ActiveRecord::Migration
  def change
    add_column :dogs, :coordinator_id, :integer
  end
end
