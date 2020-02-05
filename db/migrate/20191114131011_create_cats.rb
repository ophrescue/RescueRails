class CreateCats < ActiveRecord::Migration[5.2]
  def change
    create_table :cat_breeds do |t|
      t.string :name
      t.timestamps
    end
    create_table :cats do |t|
      t.string :name
      t.string :original_name
      t.integer :tracking_id
      t.integer :primary_breed_id
      t.integer :secondary_breed_id
      t.string :status
      t.string :age, limit: 75
      t.string :size, limit: 75
      t.boolean :is_altered
      t.string :gender, limit: 6
      t.boolean :declawed
      t.boolean :litter_box_trained
      t.string :coat_length
      t.boolean :is_special_needs
      t.boolean :no_dogs
      t.boolean :no_cats
      t.boolean :no_kids
      t.text :description
      t.integer :foster_id
      t.date :adoption_date
      t.boolean :is_uptodateonshots, default: true
      t.date :intake_dt
      t.date :available_on_dt
      t.boolean :has_medical_need, default: false
      t.boolean :is_high_priority, default: false
      t.boolean :needs_photos, default: false
      t.boolean :has_behavior_problem, default: false
      t.boolean :needs_foster, default: false
      t.string :petfinder_ad_url
      t.string :craigslist_ad_url
      t.string :youtube_video_url
      t.string :microchip
      t.integer :fee
      t.integer :coordinator_id
      t.string :sponsored_by
      t.integer :shelter_id
      t.text :medical_summary
      t.text :behavior_summary
      t.boolean :medical_review_complete, default: false
      t.string :first_shots
      t.string :second_shots
      t.string :third_shots
      t.string :rabies
      t.string :felv_fiv_test
      t.string :flea_tick_preventative
      t.string :dewormer
      t.string :coccidia_treatment
      t.timestamps
    end
  end

  def up
    add_index :cats, :tracking_id, unique: true
    say "Creating sequence for cat trackingID  starting at 1"
    execute 'CREATE SEQUENCE cat_tracking_id_seq START 1;'
  end

  def down
    remove_index :cats, :tracking_id
    execute 'DROP SEQUENCE IF EXISTS cat_tracking_id_seq;'
  end
end
