class CreateVolunteerFosterApps < ActiveRecord::Migration[6.0]
  def change
    create_table :volunteer_foster_apps do |t|
      t.belongs_to :volunteer_app, index: { unique: true }, foreign_key: true
      t.boolean :can_foster_dogs
      t.boolean :can_foster_cats
      t.string :home_type
      t.text :rental_restrictions
      t.string :rental_landlord_name
      t.text :rental_landlord_info
      t.boolean :has_pets
      t.text :vet_info
      t.text :current_pets
      t.text :current_pets_spay_neuter
      t.text :about_family
      t.text :breed_pref
      t.date :ready_to_foster_dt
      t.string :foster_term
      t.integer :max_time_alone
      t.boolean :dog_fenced_in_yard
      t.text :dog_exercise
      t.text :kept_during_day
      t.text :kept_at_night
      t.text :kept_when_alone
      t.timestamps
    end
  end
end
