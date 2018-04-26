class AddLandLordEmailToAdoptionApp < ActiveRecord::Migration[4.2]
  def change
    add_column :adoption_apps, :landlord_email, :string
  end
end
