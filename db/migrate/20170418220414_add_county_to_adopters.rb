class AddCountyToAdopters < ActiveRecord::Migration[5.0]
  def change
    add_column :adopters, :county, :string
  end
end
