
class AddCanFosterToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :can_foster_cats, :boolean, default: false
    add_column :users, :can_foster_dogs, :boolean, default: false
  end
end
