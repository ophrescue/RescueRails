class AddNotNullToUserEmailAndPassword < ActiveRecord::Migration[5.0]
  def change
    change_column_null(:users, :email, false)
    change_column_null(:users, :encrypted_password, false)
  end
end
