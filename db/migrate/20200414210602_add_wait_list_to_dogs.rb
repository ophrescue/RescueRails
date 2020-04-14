class AddWaitListToDogs < ActiveRecord::Migration[5.2]
  def change
    add_column :dogs, :wait_list, :text
  end
end
