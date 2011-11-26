class FixColumnName < ActiveRecord::Migration
  def change
  	rename_column :adoptions, :type, :relation_type
  end

end
