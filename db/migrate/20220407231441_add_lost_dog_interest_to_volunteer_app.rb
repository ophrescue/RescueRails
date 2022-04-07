class AddLostDogInterestToVolunteerApp < ActiveRecord::Migration[6.0]
  def change
    add_column :volunteer_apps, :lost_dog_interest, :boolean, null: false, default: false
  end
end
