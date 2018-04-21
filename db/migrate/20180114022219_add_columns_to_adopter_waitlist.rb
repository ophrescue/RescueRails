class AddColumnsToAdopterWaitlist < ActiveRecord::Migration[5.0]
  def change
    add_column :adopter_waitlists, :adopter_id, :integer
    add_column :adopter_waitlists, :waitlist_id, :integer
  end
end
