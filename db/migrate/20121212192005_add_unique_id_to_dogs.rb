class AddUniqueIdToDogs < ActiveRecord::Migration
  def up
  	add_index :dogs, :tracking_id, :unique => true

  	say "Creating sequence for dog trackingID  starting at 2000"
    execute 'CREATE SEQUENCE tracking_id_seq START 2000;'

  end
  def down
  	remove_index :dogs, :tracking_id

  	execute 'DROP SEQUENCE IF EXISTS tracking_id_seq;'
  end
end
