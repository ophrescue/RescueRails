class RenameHeartWormTo4Dx < ActiveRecord::Migration[5.0]
  def change
    rename_column :dogs, :heartworm, :vac_4dx
  end
end
