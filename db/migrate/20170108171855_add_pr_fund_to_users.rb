class AddPrFundToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :public_relations, :boolean, default: false
    add_column :users, :fundraising, :boolean, default: false
  end
end
