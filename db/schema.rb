# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130216203554) do

  create_table "adopters", :force => true do |t|
    t.string    "name"
    t.string    "email"
    t.string    "phone"
    t.string    "address1"
    t.string    "address2"
    t.string    "city"
    t.string    "state"
    t.string    "zip"
    t.string    "status"
    t.string    "when_to_call"
    t.timestamp "created_at",          :limit => 6
    t.timestamp "updated_at",          :limit => 6
    t.text      "dog_reqs"
    t.text      "why_adopt"
    t.string    "dog_name"
    t.string    "other_phone"
    t.integer   "assigned_to_user_id"
    t.string    "flag"
    t.boolean   "is_subscribed",                    :default => false
  end

  create_table "adoption_apps", :force => true do |t|
    t.integer   "adopter_id"
    t.string    "spouse_name",               :limit => 50
    t.string    "other_household_names"
    t.date      "ready_to_adopt_dt"
    t.string    "house_type",                :limit => 40
    t.text      "dog_exercise"
    t.string    "dog_stay_when_away",        :limit => 100
    t.text      "dog_vacation"
    t.text      "current_pets"
    t.text      "why_not_fixed"
    t.boolean   "current_pets_uptodate"
    t.text      "current_pets_uptodate_why"
    t.string    "landlord_name",             :limit => 100
    t.string    "landlord_phone",            :limit => 15
    t.text      "rent_dog_restrictions"
    t.text      "surrender_pet_causes"
    t.text      "training_explain"
    t.text      "surrendered_pets"
    t.timestamp "created_at",                :limit => 6
    t.timestamp "updated_at",                :limit => 6
    t.string    "how_did_you_hear"
    t.string    "pets_branch"
    t.boolean   "current_pets_fixed"
    t.text      "rent_costs"
    t.text      "vet_info"
    t.integer   "max_hrs_alone"
    t.boolean   "is_ofage"
  end

  add_index "adoption_apps", ["adopter_id"], :name => "index_adoption_apps_on_adopter_id"

  create_table "adoptions", :force => true do |t|
    t.integer   "adopter_id"
    t.integer   "dog_id"
    t.string    "relation_type"
    t.timestamp "created_at",    :limit => 6
    t.timestamp "updated_at",    :limit => 6
  end

  add_index "adoptions", ["adopter_id", "dog_id"], :name => "index_connections_on_adopter_id_and_dog_id", :unique => true
  add_index "adoptions", ["adopter_id"], :name => "index_connections_on_adopter_id"
  add_index "adoptions", ["dog_id"], :name => "index_connections_on_dog_id"

  create_table "attachments", :force => true do |t|
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer  "updated_by_user_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.text     "description"
  end

  create_table "banned_adopters", :force => true do |t|
    t.string   "name",       :limit => 100
    t.string   "phone",      :limit => 20
    t.string   "email",      :limit => 100
    t.string   "city",       :limit => 100
    t.string   "state",      :limit => 2
    t.text     "comment"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "banned_adopters", ["name"], :name => "index_banned_adopters_on_name"

  create_table "breeds", :force => true do |t|
    t.string    "name"
    t.timestamp "created_at", :limit => 6
    t.timestamp "updated_at", :limit => 6
  end

  add_index "breeds", ["name"], :name => "index_breeds_on_name"

  create_table "comments", :force => true do |t|
    t.text      "content"
    t.integer   "commentable_id"
    t.string    "commentable_type"
    t.integer   "user_id"
    t.timestamp "created_at",       :limit => 6
    t.timestamp "updated_at",       :limit => 6
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer   "priority",                :default => 0
    t.integer   "attempts",                :default => 0
    t.text      "handler"
    t.text      "last_error"
    t.timestamp "run_at",     :limit => 6
    t.timestamp "locked_at",  :limit => 6
    t.timestamp "failed_at",  :limit => 6
    t.string    "locked_by"
    t.timestamp "created_at", :limit => 6
    t.timestamp "updated_at", :limit => 6
    t.string    "queue"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "dogs", :force => true do |t|
    t.string    "name"
    t.timestamp "created_at",           :limit => 6
    t.timestamp "updated_at",           :limit => 6
    t.integer   "tracking_id"
    t.integer   "primary_breed_id"
    t.integer   "secondary_breed_id"
    t.string    "status"
    t.string    "age",                  :limit => 75
    t.string    "size",                 :limit => 75
    t.boolean   "is_altered"
    t.string    "gender",               :limit => 6
    t.boolean   "is_special_needs"
    t.boolean   "no_dogs"
    t.boolean   "no_cats"
    t.boolean   "no_kids"
    t.text      "description"
    t.integer   "foster_id"
    t.date      "adoption_date"
    t.boolean   "is_uptodateonshots",                 :default => true
    t.date      "intake_dt"
    t.date      "available_on_dt"
    t.boolean   "has_medical_need",                   :default => false
    t.boolean   "is_high_priority",                   :default => false
    t.boolean   "needs_photos",                       :default => false
    t.boolean   "has_behavior_problem",               :default => false
    t.boolean   "needs_foster",                       :default => false
    t.string    "petfinder_ad_url"
    t.string    "adoptapet_ad_url"
    t.string    "craigslist_ad_url"
    t.string    "youtube_video_url"
    t.string    "first_shots"
    t.string    "second_shots"
    t.string    "third_shots"
    t.string    "rabies"
    t.string    "heartworm"
    t.string    "bordetella"
    t.string    "microchip"
    t.string    "original_name"
    t.integer   "fee"
    t.integer   "coordinator_id"
  end

  add_index "dogs", ["age"], :name => "index_dogs_on_age"
  add_index "dogs", ["foster_id"], :name => "index_dogs_on_user_id"
  add_index "dogs", ["gender"], :name => "index_dogs_on_gender"
  add_index "dogs", ["name"], :name => "index_dogs_on_name"
  add_index "dogs", ["primary_breed_id"], :name => "index_dogs_on_primary_breed_id"
  add_index "dogs", ["secondary_breed_id"], :name => "index_dogs_on_secondary_breed_id"
  add_index "dogs", ["size"], :name => "index_dogs_on_size"
  add_index "dogs", ["tracking_id"], :name => "index_dogs_on_tracking_id", :unique => true

  create_table "emails", :force => true do |t|
    t.string    "from_address",                  :null => false
    t.string    "reply_to_address"
    t.string    "subject"
    t.text      "to_address"
    t.text      "cc_address"
    t.text      "bcc_address"
    t.text      "content"
    t.timestamp "sent_at",          :limit => 6
    t.timestamp "created_at",       :limit => 6
    t.timestamp "updated_at",       :limit => 6
  end

  create_table "events", :force => true do |t|
    t.string    "title"
    t.string    "location_name"
    t.string    "address"
    t.text      "description"
    t.integer   "created_by_user"
    t.timestamp "created_at",         :limit => 6
    t.timestamp "updated_at",         :limit => 6
    t.float     "latitude"
    t.float     "longitude"
    t.date      "event_date"
    t.time      "start_time",         :limit => 6
    t.time      "end_time",           :limit => 6
    t.string    "location_url"
    t.string    "location_phone"
    t.string    "photo_file_name"
    t.string    "photo_content_type"
    t.integer   "photo_file_size"
    t.timestamp "photo_updated_at",   :limit => 6
    t.string    "photographer_name"
    t.string    "photographer_url"
  end

  add_index "events", ["event_date"], :name => "index_events_on_event_date"

  create_table "folders", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "photos", :force => true do |t|
    t.integer   "dog_id"
    t.string    "photo_file_name"
    t.string    "photo_content_type"
    t.integer   "photo_file_size"
    t.timestamp "photo_updated_at",   :limit => 6
    t.timestamp "created_at",         :limit => 6
    t.timestamp "updated_at",         :limit => 6
    t.integer   "position"
  end

  add_index "photos", ["dog_id"], :name => "index_photos_on_dog_id"

  create_table "references", :force => true do |t|
    t.integer   "adopter_id"
    t.string    "name"
    t.string    "email"
    t.string    "phone"
    t.string    "relationship"
    t.timestamp "created_at",   :limit => 6
    t.timestamp "updated_at",   :limit => 6
    t.string    "whentocall"
  end

  add_index "references", ["adopter_id"], :name => "index_references_on_adopter_id"

  create_table "users", :force => true do |t|
    t.string    "name"
    t.string    "email"
    t.timestamp "created_at",             :limit => 6
    t.timestamp "updated_at",             :limit => 6
    t.string    "encrypted_password"
    t.string    "salt"
    t.boolean   "admin",                               :default => false
    t.string    "password_reset_token"
    t.timestamp "password_reset_sent_at", :limit => 6
    t.boolean   "is_foster",                           :default => false
    t.string    "phone"
    t.string    "address1"
    t.string    "address2"
    t.string    "city"
    t.string    "state"
    t.string    "zip"
    t.string    "duties"
    t.boolean   "edit_dogs",                           :default => false
    t.text      "share_info"
    t.boolean   "edit_my_adopters",                    :default => false
    t.boolean   "edit_all_adopters",                   :default => false
    t.boolean   "locked",                              :default => false
    t.boolean   "edit_events",                         :default => false
    t.string    "other_phone"
    t.datetime  "lastlogin"
    t.datetime  "lastverified"
    t.boolean   "available_to_foster",                 :default => false
    t.text      "foster_dog_types"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["name"], :name => "index_users_on_name"

end
