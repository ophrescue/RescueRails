class AddHowHearColumn < ActiveRecord::Migration
  def change
  	add_column :adoption_apps, :how_did_you_hear, :string
  end

end
