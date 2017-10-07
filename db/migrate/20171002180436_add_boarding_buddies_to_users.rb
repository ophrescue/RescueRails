class AddBoardingBuddiesToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :boarding_buddies, :boolean, default: false, null: false
  end
end
