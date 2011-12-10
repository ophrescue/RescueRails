class Adddognametoadopter < ActiveRecord::Migration
  def change
  	  add_column :adopters, :dog_name, :string
  end

end
