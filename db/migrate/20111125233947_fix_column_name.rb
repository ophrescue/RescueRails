class FixColumnName < ActiveRecord::Migration[4.2]
  def change
    rename_column :adoptions, :type, :relation_type
  end

end
