class AddIsMixToDogs < ActiveRecord::Migration[4.2]
  def change
    add_column :dogs, :is_mix, :boolean
  end
end
