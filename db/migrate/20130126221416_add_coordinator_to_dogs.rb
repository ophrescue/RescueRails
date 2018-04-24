class AddCoordinatorToDogs < ActiveRecord::Migration[4.2]
  def change
    add_column :dogs, :coordinator_id, :integer
  end
end
