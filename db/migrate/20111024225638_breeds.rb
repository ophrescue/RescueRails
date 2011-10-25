class Breeds < ActiveRecord::Migration
  def change
	  create_table :breeds do |t|
	  	t.string :name 

	  	t.timestamps
	  end
  end

end
