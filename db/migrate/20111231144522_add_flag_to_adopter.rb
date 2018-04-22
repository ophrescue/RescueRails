class AddFlagToAdopter < ActiveRecord::Migration[4.2]
  def change
    add_column :adopters, :flag, :string
  end
end
