class AddLandLordEmailToAdoptionApp < ActiveRecord::Migration
  def change
    add_column :adoption_apps, :landlord_email, :string
  end
end
