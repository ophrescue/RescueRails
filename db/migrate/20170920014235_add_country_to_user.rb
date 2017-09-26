class AddCountryToUser < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :country, :string, limit: 3, comment: 'Country as a ISO 3166-1 alpha-3 code'
    execute "UPDATE users SET country = 'USA';"
  end

  def down
    remove_column :users, :country
  end
end
