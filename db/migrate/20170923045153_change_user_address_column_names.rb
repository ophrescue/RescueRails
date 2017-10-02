class ChangeUserAddressColumnNames < ActiveRecord::Migration[5.0] 
  def up
    incompatible_records = execute("SELECT id, name, email, state FROM users WHERE LENGTH(state) > 2;")
    raise "Migration aborted beacuse legacy data contains users with states that are more than two letters: #{incompatible_records.to_a}" unless incompatible_records.to_a.empty?
    
    rename_column :users, :state, :region 
    change_column :users, :region, :string, limit: 2, comment: 'Region (state or province) as a 2 character ISO 3166-2 code' 
 
    rename_column :users, :zip, :postal_code 
    change_column_comment :users, :postal_code, 'Postal code - ZIP code for US addresses' 
  end 
 
  def down 
    rename_column :users, :region, :state 
    change_column :users, :state, :string, limit: 255, comment: '' 
 
    rename_column :users, :postal_code, :zip 
    
    # Remove inapplicable comment
    change_column_comment :users, :zip, '' 
  end 
end 