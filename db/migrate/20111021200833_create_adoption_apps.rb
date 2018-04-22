class CreateAdoptionApps < ActiveRecord::Migration[4.2]
  def change
    create_table :adoption_apps do |t|
      t.integer :adopter_id
      t.string :spouse_name, limit: 50
      t.string :other_household_names
      t.date :ready_to_adopt_dt
      t.string :house_type, limit: 40
      t.text :dog_reqs
      t.boolean :has_yard
      t.boolean :has_fence
      t.boolean :has_parks
      t.text :dog_exercise
      t.string :dog_stay_when_away, limit: 100
      t.integer :max_hrs_alone, default: 8
      t.string :dog_at_night, limit: 100
      t.text :dog_vacation
      t.boolean :have_pets
      t.boolean :had_pets
      t.text :current_pets
      t.string :current_pets_fixed, limit: 50
      t.text :why_not_fixed
      t.text :prior_pets
      t.boolean :current_pets_uptodate
      t.text :current_pets_uptodate_why
      t.string :vet_name,  limit: 100
      t.string :vet_phone, limit: 15
      t.string :landlord_name, limit: 100
      t.string :landlord_phone, limit: 15
      t.text :rent_dog_restrictions
      t.integer :rent_deposit, default: 0
      t.integer :rent_increase, default: 0
      t.integer :annual_cost_est, default: 0
      t.text :plan_training
      t.boolean :has_new_dog_exp
      t.text :surrender_pet_causes
      t.text :training_explain
      t.text :surrendered_pets
      t.text :why_adopt

      t.timestamps
    end
    add_index :adoption_apps, :adopter_id
  end
end
