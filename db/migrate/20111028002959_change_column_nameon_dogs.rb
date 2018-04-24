class ChangeColumnNameonDogs < ActiveRecord::Migration[4.2]
  def up
    remove_column :dogs, :is_mix
    add_column    :dogs, :is_purebred, :boolean
  end

  def down
    add_column  	 :dogs, :is_mix, :boolean
    remove_column    :dogs, :is_purebred
  end
end
