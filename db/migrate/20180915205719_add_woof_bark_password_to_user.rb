class AddWoofBarkPasswordToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :woof_bark_password, :string
  end
end
