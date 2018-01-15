class AddWaitlistToDogs < ActiveRecord::Migration[5.0]
  def change
    add_column :dogs, :waitlist_id, :integer
    add_index  :dogs, :waitlist_id
  end
end
