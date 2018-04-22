class Adddognametoadopter < ActiveRecord::Migration[4.2]
  def change
      add_column :adopters, :dog_name, :string
  end

end
