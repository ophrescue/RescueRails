# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_04_30_214358) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "adopters", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "status"
    t.string "when_to_call"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "dog_reqs"
    t.text "why_adopt"
    t.string "dog_name"
    t.string "other_phone"
    t.integer "assigned_to_user_id"
    t.string "flag"
    t.boolean "is_subscribed", default: false
    t.date "completed_date"
    t.string "county"
    t.boolean "training_email_sent", default: false, null: false
    t.string "dog_or_cat"
    t.string "secondary_email"
    t.boolean "is_address_valid", default: true
    t.index ["assigned_to_user_id"], name: "index_adopters_on_assigned_to_user_id"
  end

  create_table "adoption_apps", id: :serial, force: :cascade do |t|
    t.integer "adopter_id"
    t.string "spouse_name", limit: 50
    t.string "other_household_names"
    t.date "ready_to_adopt_dt"
    t.string "house_type", limit: 40
    t.text "dog_exercise"
    t.string "dog_stay_when_away", limit: 100
    t.text "dog_vacation"
    t.text "current_pets"
    t.text "why_not_fixed"
    t.boolean "current_pets_uptodate"
    t.text "current_pets_uptodate_why"
    t.string "landlord_name", limit: 100
    t.string "landlord_phone", limit: 15
    t.text "rent_dog_restrictions"
    t.text "surrender_pet_causes"
    t.text "training_explain"
    t.text "surrendered_pets"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "how_did_you_hear"
    t.string "pets_branch"
    t.boolean "current_pets_fixed"
    t.text "rent_costs"
    t.text "vet_info"
    t.integer "max_hrs_alone"
    t.boolean "is_ofage"
    t.string "landlord_email"
    t.boolean "shot_dhpp_dhlpp"
    t.boolean "shot_fpv_fhv_fcv"
    t.boolean "shot_rabies"
    t.boolean "shot_bordetella"
    t.boolean "shot_heartworm"
    t.boolean "shot_flea_tick"
    t.boolean "verify_home_auth", default: false
    t.boolean "has_family_under_18"
    t.date "birth_date"
    t.string "prev_pets_type"
    t.string "current_pets_type"
    t.string "building_type"
    t.boolean "fenced_yard"
    t.index ["adopter_id"], name: "index_adoption_apps_on_adopter_id"
  end

  create_table "adoptions", id: :serial, force: :cascade do |t|
    t.integer "adopter_id"
    t.integer "dog_id"
    t.string "relation_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["adopter_id", "dog_id"], name: "index_adoptions_on_adopter_id_and_dog_id", unique: true
    t.index ["adopter_id"], name: "index_adoptions_on_adopter_id"
    t.index ["dog_id"], name: "index_adoptions_on_dog_id"
  end

  create_table "attachments", id: :serial, force: :cascade do |t|
    t.integer "attachable_id"
    t.string "attachable_type"
    t.string "attachment_file_name"
    t.string "attachment_content_type"
    t.integer "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer "updated_by_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "description"
    t.string "agreement_type"
  end

  create_table "audits", id: :serial, force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.jsonb "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_id", "associated_type"], name: "associated_index"
    t.index ["auditable_id", "auditable_type"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "banned_adopters", id: :serial, force: :cascade do |t|
    t.string "name", limit: 100
    t.string "phone", limit: 20
    t.string "email", limit: 100
    t.string "city", limit: 100
    t.string "state", limit: 2
    t.text "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "index_banned_adopters_on_name"
  end

  create_table "breeds", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "index_breeds_on_name"
  end

  create_table "campaigns", force: :cascade do |t|
    t.string "title"
    t.integer "goal"
    t.text "summary"
    t.integer "created_by_user_id"
    t.text "description"
    t.string "primary_photo_file_name"
    t.string "primary_photo_content_type"
    t.integer "primary_photo_file_size"
    t.datetime "primary_photo_updated_at"
    t.string "left_photo_file_name"
    t.string "left_photo_content_type"
    t.integer "left_photo_file_size"
    t.datetime "left_photo_updated_at"
    t.string "middle_photo_file_name"
    t.string "middle_photo_content_type"
    t.integer "middle_photo_file_size"
    t.datetime "middle_photo_updated_at"
    t.string "right_photo_file_name"
    t.string "right_photo_content_type"
    t.integer "right_photo_file_size"
    t.datetime "right_photo_updated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
  end

  create_table "cat_adoptions", force: :cascade do |t|
    t.integer "adopter_id"
    t.integer "cat_id"
    t.string "relation_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["adopter_id", "cat_id"], name: "index_cat_adoptions_on_adopter_id_and_cat_id", unique: true
    t.index ["adopter_id"], name: "index_cat_adoptions_on_adopter_id"
    t.index ["cat_id"], name: "index_cat_adoptions_on_cat_id"
  end

  create_table "cat_breeds", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cats", force: :cascade do |t|
    t.string "name"
    t.string "original_name"
    t.integer "tracking_id"
    t.integer "primary_breed_id"
    t.integer "secondary_breed_id"
    t.string "status"
    t.string "age", limit: 75
    t.string "size", limit: 75
    t.boolean "is_altered"
    t.string "gender", limit: 6
    t.boolean "declawed"
    t.boolean "litter_box_trained"
    t.string "coat_length"
    t.boolean "is_special_needs"
    t.boolean "no_dogs"
    t.boolean "no_cats"
    t.boolean "no_kids"
    t.text "description"
    t.integer "foster_id"
    t.date "adoption_date"
    t.boolean "is_uptodateonshots", default: true
    t.date "intake_dt"
    t.date "available_on_dt"
    t.boolean "has_medical_need", default: false
    t.boolean "is_high_priority", default: false
    t.boolean "needs_photos", default: false
    t.boolean "has_behavior_problem", default: false
    t.boolean "needs_foster", default: false
    t.string "petfinder_ad_url"
    t.string "craigslist_ad_url"
    t.string "youtube_video_url"
    t.string "microchip"
    t.integer "fee"
    t.integer "coordinator_id"
    t.string "sponsored_by"
    t.integer "shelter_id"
    t.text "medical_summary"
    t.text "behavior_summary"
    t.boolean "medical_review_complete", default: false
    t.string "first_shots"
    t.string "second_shots"
    t.string "third_shots"
    t.string "rabies"
    t.string "felv_fiv_test"
    t.string "flea_tick_preventative"
    t.string "dewormer"
    t.string "coccidia_treatment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "hidden", default: false, null: false
    t.boolean "no_urban_setting", default: false, null: false
    t.boolean "home_check_required", default: false, null: false
  end

  create_table "comments", id: :serial, force: :cascade do |t|
    t.text "content"
    t.integer "commentable_id"
    t.string "commentable_type"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["commentable_id"], name: "index_comments_on_commentable_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "contracts", force: :cascade do |t|
    t.string "contractable_type"
    t.integer "contractable_id"
    t.string "esig_contract_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "delayed_jobs", id: :serial, force: :cascade do |t|
    t.integer "priority", default: 0
    t.integer "attempts", default: 0
    t.text "handler"
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "queue"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "dogs", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "tracking_id"
    t.integer "primary_breed_id"
    t.integer "secondary_breed_id"
    t.string "status"
    t.string "age", limit: 75
    t.string "size", limit: 75
    t.boolean "is_altered"
    t.string "gender", limit: 6
    t.boolean "is_special_needs"
    t.boolean "no_dogs"
    t.boolean "no_cats"
    t.boolean "no_kids"
    t.text "description"
    t.integer "foster_id"
    t.date "adoption_date"
    t.boolean "is_uptodateonshots", default: true
    t.date "intake_dt"
    t.date "available_on_dt"
    t.boolean "has_medical_need", default: false
    t.boolean "is_high_priority", default: false
    t.boolean "needs_photos", default: false
    t.boolean "has_behavior_problem", default: false
    t.boolean "needs_foster", default: false
    t.string "petfinder_ad_url"
    t.string "craigslist_ad_url"
    t.string "youtube_video_url"
    t.string "first_shots"
    t.string "second_shots"
    t.string "third_shots"
    t.string "rabies"
    t.string "vac_4dx"
    t.string "bordetella"
    t.string "microchip"
    t.string "original_name"
    t.integer "fee"
    t.integer "coordinator_id"
    t.string "sponsored_by"
    t.integer "shelter_id"
    t.text "medical_summary"
    t.string "heartworm_preventative"
    t.string "flea_tick_preventative"
    t.boolean "medical_review_complete", default: false
    t.text "behavior_summary"
    t.string "dewormer"
    t.string "toltrazuril"
    t.boolean "hidden", default: false, null: false
    t.text "wait_list"
    t.boolean "no_urban_setting", default: false, null: false
    t.boolean "home_check_required", default: false, null: false
    t.index ["age"], name: "index_dogs_on_age"
    t.index ["coordinator_id"], name: "index_dogs_on_coordinator_id"
    t.index ["foster_id"], name: "index_dogs_on_foster_id"
    t.index ["gender"], name: "index_dogs_on_gender"
    t.index ["name"], name: "index_dogs_on_name"
    t.index ["primary_breed_id"], name: "index_dogs_on_primary_breed_id"
    t.index ["secondary_breed_id"], name: "index_dogs_on_secondary_breed_id"
    t.index ["shelter_id"], name: "index_dogs_on_shelter_id"
    t.index ["size"], name: "index_dogs_on_size"
    t.index ["tracking_id"], name: "index_dogs_on_tracking_id", unique: true
  end

  create_table "donations", force: :cascade do |t|
    t.string "stripe_customer_id"
    t.string "name"
    t.string "email"
    t.integer "amount"
    t.string "frequency"
    t.string "card_token"
    t.boolean "notify_someone"
    t.string "notify_name"
    t.string "notify_email"
    t.string "notify_message"
    t.boolean "is_memory_honor"
    t.string "memory_honor_type"
    t.string "memory_honor_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "comment"
    t.integer "campaign_id"
    t.boolean "more_contact_info", default: false
    t.string "phone"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "region", limit: 2
    t.string "postal_code"
  end

  create_table "emails", id: :serial, force: :cascade do |t|
    t.string "from_address", null: false
    t.string "reply_to_address"
    t.string "subject"
    t.text "to_address"
    t.text "cc_address"
    t.text "bcc_address"
    t.text "content"
    t.datetime "sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "location_name"
    t.string "address"
    t.text "description"
    t.integer "created_by_user"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float "latitude"
    t.float "longitude"
    t.date "event_date"
    t.time "start_time"
    t.time "end_time"
    t.string "location_url"
    t.string "location_phone"
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at"
    t.string "photographer_name"
    t.string "photographer_url"
    t.string "facebook_url"
    t.boolean "featured", default: false, null: false
    t.index ["event_date"], name: "index_events_on_event_date"
  end

  create_table "folders", id: :serial, force: :cascade do |t|
    t.text "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "locked", default: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.integer "invoiceable_id"
    t.string "invoiceable_type"
    t.string "slug"
    t.integer "amount"
    t.string "status"
    t.bigint "user_id"
    t.text "description"
    t.string "stripe_customer_id"
    t.string "card_token"
    t.datetime "paid_at"
    t.string "paid_method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "donation_id"
    t.boolean "has_donation", default: false, null: false
    t.datetime "contract_received_at"
    t.index ["donation_id"], name: "index_invoices_on_donation_id"
    t.index ["slug"], name: "index_invoices_on_slug", unique: true
    t.index ["user_id"], name: "index_invoices_on_user_id"
  end

  create_table "photos", id: :serial, force: :cascade do |t|
    t.integer "dog_id"
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "position"
    t.boolean "is_private", default: false
    t.string "animal_type"
    t.bigint "animal_id"
    t.index ["animal_type", "animal_id"], name: "index_photos_on_animal_type_and_animal_id"
    t.index ["dog_id"], name: "index_photos_on_dog_id"
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "user_id"
    t.string "type"
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["slug"], name: "index_posts_on_slug", unique: true
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "references", id: :serial, force: :cascade do |t|
    t.integer "adopter_id"
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "relationship"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "whentocall"
    t.index ["adopter_id"], name: "index_references_on_adopter_id"
  end

  create_table "shelters", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "treatment_records", force: :cascade do |t|
    t.integer "treatment_id"
    t.bigint "user_id"
    t.integer "treatable_id"
    t.string "treatable_type"
    t.date "administered_date"
    t.date "due_date"
    t.string "result"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["treatment_id"], name: "index_treatment_records_on_treatment_id"
    t.index ["user_id"], name: "index_treatment_records_on_user_id"
  end

  create_table "treatments", force: :cascade do |t|
    t.string "name", null: false
    t.string "available_for", null: false
    t.boolean "has_result", default: false, null: false
    t.text "recommendation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "encrypted_password"
    t.string "salt"
    t.boolean "admin", default: false
    t.string "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.boolean "is_foster", default: false
    t.string "phone"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "region", limit: 2, comment: "Region (state or province) as a 2 character ISO 3166-2 code"
    t.string "postal_code", comment: "Postal code - ZIP code for US addresses"
    t.string "duties"
    t.boolean "edit_dogs", default: false
    t.text "share_info"
    t.boolean "edit_my_adopters", default: false
    t.boolean "edit_all_adopters", default: false
    t.boolean "locked", default: false
    t.boolean "edit_events", default: false
    t.string "other_phone"
    t.datetime "lastlogin"
    t.datetime "lastverified"
    t.boolean "available_to_foster", default: false
    t.text "foster_dog_types"
    t.boolean "complete_adopters", default: false
    t.boolean "add_dogs", default: false
    t.boolean "ban_adopters", default: false
    t.boolean "dl_resources", default: true
    t.integer "agreement_id"
    t.string "house_type", limit: 40
    t.boolean "breed_restriction"
    t.boolean "weight_restriction"
    t.boolean "has_own_dogs"
    t.boolean "has_own_cats"
    t.boolean "children_under_five"
    t.boolean "has_fenced_yard"
    t.boolean "can_foster_puppies"
    t.boolean "parvo_house"
    t.text "admin_comment"
    t.boolean "is_photographer", default: false
    t.boolean "writes_newsletter", default: false
    t.boolean "is_transporter", default: false
    t.integer "mentor_id"
    t.float "latitude"
    t.float "longitude"
    t.boolean "dl_locked_resources", default: false
    t.boolean "training_team", default: false
    t.integer "confidentiality_agreement_id"
    t.boolean "foster_mentor", default: false
    t.boolean "public_relations", default: false
    t.boolean "fundraising", default: false
    t.boolean "translator", default: false, null: false
    t.string "known_languages", limit: 255
    t.integer "code_of_conduct_agreement_id"
    t.boolean "medical_behavior_permission", default: false
    t.boolean "boarding_buddies", default: false, null: false
    t.boolean "social_media_manager", default: false, null: false
    t.boolean "graphic_design", default: false, null: false
    t.string "country", limit: 3, null: false, comment: "Country as a ISO 3166-1 alpha-3 code"
    t.boolean "active", default: false, null: false, comment: "if false user is a candiate volunteer and should only be able to see and edit their profile"
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean "has_children", default: false
    t.integer "insurance_training_agreement_id"
    t.boolean "dog_handling_training_complete", default: false, null: false
    t.boolean "cat_handling_training_complete", default: false, null: false
    t.index ["agreement_id"], name: "index_users_on_agreement_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["latitude", "longitude"], name: "index_users_on_latitude_and_longitude"
    t.index ["mentor_id"], name: "index_users_on_mentor_id"
    t.index ["name"], name: "index_users_on_name"
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end

  create_table "volunteer_apps", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "region", limit: 2, comment: "Region (state or province) as a 2 character ISO 3166-2 code"
    t.string "postal_code", comment: "Postal code - ZIP code for US addresses"
    t.string "referrer"
    t.boolean "events_interest"
    t.boolean "fostering_interest"
    t.boolean "training_interest"
    t.boolean "fundraising_interest"
    t.boolean "transport_bb_interest"
    t.boolean "adoption_team_interest"
    t.boolean "admin_interest"
    t.text "about"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "marketing_interest"
  end

  create_table "volunteer_foster_apps", force: :cascade do |t|
    t.bigint "volunteer_app_id"
    t.boolean "can_foster_dogs"
    t.boolean "can_foster_cats"
    t.string "home_type"
    t.text "rental_restrictions"
    t.string "rental_landlord_name"
    t.text "rental_landlord_info"
    t.boolean "has_pets"
    t.text "vet_info"
    t.text "current_pets"
    t.text "current_pets_spay_neuter"
    t.text "about_family"
    t.text "breed_pref"
    t.date "ready_to_foster_dt"
    t.integer "max_time_alone"
    t.boolean "dog_fenced_in_yard"
    t.text "dog_exercise"
    t.text "kept_during_day"
    t.text "kept_at_night"
    t.text "kept_when_alone"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "foster_experience"
    t.index ["volunteer_app_id"], name: "index_volunteer_foster_apps_on_volunteer_app_id", unique: true
  end

  create_table "volunteer_references", force: :cascade do |t|
    t.bigint "volunteer_app_id"
    t.string "name"
    t.string "email"
    t.string "phone"
    t.string "relationship"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["volunteer_app_id"], name: "index_volunteer_references_on_volunteer_app_id"
  end

  add_foreign_key "invoices", "donations"
  add_foreign_key "invoices", "users"
  add_foreign_key "treatment_records", "treatments"
  add_foreign_key "treatment_records", "users"
  add_foreign_key "volunteer_foster_apps", "volunteer_apps"
  add_foreign_key "volunteer_references", "volunteer_apps"
end
