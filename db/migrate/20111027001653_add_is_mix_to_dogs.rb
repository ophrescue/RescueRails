class AddIsMixToDogs < ActiveRecord::Migration
  def change
    add_column :dogs, :is_mix, :boolean
  end
end
