class AddWaitListToCats < ActiveRecord::Migration[6.0]
  def change
    add_column :cats, :wait_list, :text
  end
end
