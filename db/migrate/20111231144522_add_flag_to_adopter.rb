class AddFlagToAdopter < ActiveRecord::Migration
  def change
  	add_column :adopters, :flag, :string
  end
end
