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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171115013311) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "adopters", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.string   "email",               limit: 255
    t.string   "phone",               limit: 255
    t.string   "address1",            limit: 255
    t.string   "address2",            limit: 255
    t.string   "city",                limit: 255
    t.string   "state",               limit: 255
    t.string   "zip",                 limit: 255
    t.string   "status",              limit: 255
    t.string   "when_to_call",        limit: 255
    t.datetime "created_at",                      precision: 6
    t.datetime "updated_at",                      precision: 6
    t.text     "dog_reqs"
    t.text     "why_adopt"
    t.string   "dog_name",            limit: 255
    t.string   "other_phone",         limit: 255
    t.integer  "assigned_to_user_id"
    t.string   "flag",                limit: 255
    t.boolean  "is_subscribed",                                 default: false
    t.date     "completed_date"
    t.string   "county"
    t.index ["assigned_to_user_id"], name: "index_adopters_on_assigned_to_user_id", using: :btree
  end

  create_table "adoption_apps", force: :cascade do |t|
    t.integer  "adopter_id"
    t.string   "spouse_name",               limit: 50
    t.string   "other_household_names",     limit: 255
    t.date     "ready_to_adopt_dt"
    t.string   "house_type",                limit: 40
    t.text     "dog_exercise"
    t.string   "dog_stay_when_away",        limit: 100
    t.text     "dog_vacation"
    t.text     "current_pets"
    t.text     "why_not_fixed"
    t.boolean  "current_pets_uptodate"
    t.text     "current_pets_uptodate_why"
    t.string   "landlord_name",             limit: 100
    t.string   "landlord_phone",            limit: 15
    t.text     "rent_dog_restrictions"
    t.text     "surrender_pet_causes"
    t.text     "training_explain"
    t.text     "surrendered_pets"
    t.datetime "created_at",                            precision: 6
    t.datetime "updated_at",                            precision: 6
    t.string   "how_did_you_hear",          limit: 255
    t.string   "pets_branch",               limit: 255
    t.boolean  "current_pets_fixed"
    t.text     "rent_costs"
    t.text     "vet_info"
    t.integer  "max_hrs_alone"
    t.boolean  "is_ofage"
    t.string   "landlord_email"
    t.boolean  "shot_dhpp_dhlpp"
    t.boolean  "shot_fpv_fhv_fcv"
    t.boolean  "shot_rabies"
    t.boolean  "shot_bordetella"
    t.boolean  "shot_heartworm"
    t.boolean  "shot_flea_tick"
    t.boolean  "verify_home_auth",                                    default: false
    t.boolean  "has_family_under_18"
    t.index ["adopter_id"], name: "index_adoption_apps_on_adopter_id", using: :btree
  end

  create_table "adoptions", force: :cascade do |t|
    t.integer  "adopter_id"
    t.integer  "dog_id"
    t.string   "relation_type", limit: 255
    t.datetime "created_at",                precision: 6
    t.datetime "updated_at",                precision: 6
    t.index ["adopter_id", "dog_id"], name: "index_connections_on_adopter_id_and_dog_id", unique: true, using: :btree
    t.index ["adopter_id"], name: "index_connections_on_adopter_id", using: :btree
    t.index ["dog_id"], name: "index_connections_on_dog_id", using: :btree
  end

  create_table "attachments", force: :cascade do |t|
    t.integer  "attachable_id"
    t.string   "attachable_type",         limit: 255
    t.string   "attachment_file_name",    limit: 255
    t.string   "attachment_content_type", limit: 255
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer  "updated_by_user_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.text     "description"
    t.string   "agreement_type"
  end

  create_table "banned_adopters", force: :cascade do |t|
    t.string   "name",       limit: 100
    t.string   "phone",      limit: 20
    t.string   "email",      limit: 100
    t.string   "city",       limit: 100
    t.string   "state",      limit: 2
    t.text     "comment"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["name"], name: "index_banned_adopters_on_name", using: :btree
  end

  create_table "breeds", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             precision: 6
    t.datetime "updated_at",             precision: 6
    t.index ["name"], name: "index_breeds_on_name", using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "commentable_id"
    t.string   "commentable_type", limit: 255
    t.integer  "user_id"
    t.datetime "created_at",                   precision: 6
    t.datetime "updated_at",                   precision: 6
    t.index ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",                             default: 0
    t.integer  "attempts",                             default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at",                 precision: 6
    t.datetime "locked_at",              precision: 6
    t.datetime "failed_at",              precision: 6
    t.string   "locked_by",  limit: 255
    t.datetime "created_at",             precision: 6
    t.datetime "updated_at",             precision: 6
    t.string   "queue",      limit: 255
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "dogs", force: :cascade do |t|
    t.string   "name",                    limit: 255
    t.datetime "created_at",                          precision: 6
    t.datetime "updated_at",                          precision: 6
    t.integer  "tracking_id"
    t.integer  "primary_breed_id"
    t.integer  "secondary_breed_id"
    t.string   "status",                  limit: 255
    t.string   "age",                     limit: 75
    t.string   "size",                    limit: 75
    t.boolean  "is_altered"
    t.string   "gender",                  limit: 6
    t.boolean  "is_special_needs"
    t.boolean  "no_dogs"
    t.boolean  "no_cats"
    t.boolean  "no_kids"
    t.text     "description"
    t.integer  "foster_id"
    t.date     "adoption_date"
    t.boolean  "is_uptodateonshots",                                default: true
    t.date     "intake_dt"
    t.date     "available_on_dt"
    t.boolean  "has_medical_need",                                  default: false
    t.boolean  "is_high_priority",                                  default: false
    t.boolean  "needs_photos",                                      default: false
    t.boolean  "has_behavior_problem",                              default: false
    t.boolean  "needs_foster",                                      default: false
    t.string   "petfinder_ad_url",        limit: 255
    t.string   "adoptapet_ad_url",        limit: 255
    t.string   "craigslist_ad_url",       limit: 255
    t.string   "youtube_video_url",       limit: 255
    t.string   "first_shots",             limit: 255
    t.string   "second_shots",            limit: 255
    t.string   "third_shots",             limit: 255
    t.string   "rabies",                  limit: 255
    t.string   "vac_4dx",                 limit: 255
    t.string   "bordetella",              limit: 255
    t.string   "microchip",               limit: 255
    t.string   "original_name",           limit: 255
    t.integer  "fee"
    t.integer  "coordinator_id"
    t.string   "sponsored_by",            limit: 255
    t.integer  "shelter_id"
    t.text     "medical_summary"
    t.string   "heartworm_preventative"
    t.string   "flea_tick_preventative"
    t.boolean  "medical_review_complete",                           default: false
    t.text     "behavior_summary"
    t.index ["age"], name: "index_dogs_on_age", using: :btree
    t.index ["coordinator_id"], name: "index_dogs_on_coordinator_id", using: :btree
    t.index ["foster_id"], name: "index_dogs_on_user_id", using: :btree
    t.index ["gender"], name: "index_dogs_on_gender", using: :btree
    t.index ["name"], name: "index_dogs_on_name", using: :btree
    t.index ["primary_breed_id"], name: "index_dogs_on_primary_breed_id", using: :btree
    t.index ["secondary_breed_id"], name: "index_dogs_on_secondary_breed_id", using: :btree
    t.index ["shelter_id"], name: "index_dogs_on_shelter_id", using: :btree
    t.index ["size"], name: "index_dogs_on_size", using: :btree
    t.index ["tracking_id"], name: "index_dogs_on_tracking_id", unique: true, using: :btree
  end

  create_table "emails", force: :cascade do |t|
    t.string   "from_address",     limit: 255,               null: false
    t.string   "reply_to_address", limit: 255
    t.string   "subject",          limit: 255
    t.text     "to_address"
    t.text     "cc_address"
    t.text     "bcc_address"
    t.text     "content"
    t.datetime "sent_at",                      precision: 6
    t.datetime "created_at",                   precision: 6
    t.datetime "updated_at",                   precision: 6
  end

  create_table "events", force: :cascade do |t|
    t.string   "title",              limit: 255
    t.string   "location_name",      limit: 255
    t.string   "address",            limit: 255
    t.text     "description"
    t.integer  "created_by_user"
    t.datetime "created_at",                     precision: 6
    t.datetime "updated_at",                     precision: 6
    t.float    "latitude"
    t.float    "longitude"
    t.date     "event_date"
    t.time     "start_time",                     precision: 6
    t.time     "end_time",                       precision: 6
    t.string   "location_url",       limit: 255
    t.string   "location_phone",     limit: 255
    t.string   "photo_file_name",    limit: 255
    t.string   "photo_content_type", limit: 255
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at",               precision: 6
    t.string   "photographer_name",  limit: 255
    t.string   "photographer_url",   limit: 255
    t.string   "facebook_url",       limit: 255
    t.index ["event_date"], name: "index_events_on_event_date", using: :btree
  end

  create_table "folders", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.boolean  "locked",                  default: false
  end

  create_table "photos", force: :cascade do |t|
    t.integer  "dog_id"
    t.string   "photo_file_name",    limit: 255
    t.string   "photo_content_type", limit: 255
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at",               precision: 6
    t.datetime "created_at",                     precision: 6
    t.datetime "updated_at",                     precision: 6
    t.integer  "position"
    t.boolean  "is_private",                                   default: false
    t.index ["dog_id"], name: "index_photos_on_dog_id", using: :btree
  end

  create_table "references", force: :cascade do |t|
    t.integer  "adopter_id"
    t.string   "name",         limit: 255
    t.string   "email",        limit: 255
    t.string   "phone",        limit: 255
    t.string   "relationship", limit: 255
    t.datetime "created_at",               precision: 6
    t.datetime "updated_at",               precision: 6
    t.string   "whentocall",   limit: 255
    t.index ["adopter_id"], name: "index_references_on_adopter_id", using: :btree
  end

  create_table "shelters", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "teams", force: :cascade do |t|
    t.string   "team_name",  limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                         limit: 255
    t.string   "email",                        limit: 255,                               null: false
    t.datetime "created_at",                               precision: 6
    t.datetime "updated_at",                               precision: 6
    t.string   "encrypted_password",           limit: 255,                               null: false
    t.string   "salt",                         limit: 255
    t.boolean  "admin",                                                  default: false
    t.string   "password_reset_token",         limit: 255
    t.datetime "password_reset_sent_at",                   precision: 6
    t.boolean  "is_foster",                                              default: false
    t.string   "phone",                        limit: 255
    t.string   "address1",                     limit: 255
    t.string   "address2",                     limit: 255
    t.string   "city",                         limit: 255
    t.string   "region",                       limit: 2,                                              comment: "Region (state or province) as a 2 character ISO 3166-2 code"
    t.string   "postal_code",                  limit: 255,                                            comment: "Postal code - ZIP code for US addresses"
    t.string   "duties",                       limit: 255
    t.boolean  "edit_dogs",                                              default: false
    t.text     "share_info"
    t.boolean  "edit_my_adopters",                                       default: false
    t.boolean  "edit_all_adopters",                                      default: false
    t.boolean  "locked",                                                 default: false
    t.boolean  "edit_events",                                            default: false
    t.string   "other_phone",                  limit: 255
    t.datetime "lastlogin"
    t.datetime "lastverified"
    t.boolean  "available_to_foster",                                    default: false
    t.text     "foster_dog_types"
    t.boolean  "complete_adopters",                                      default: false
    t.boolean  "add_dogs",                                               default: false
    t.boolean  "ban_adopters",                                           default: false
    t.boolean  "dl_resources",                                           default: true
    t.integer  "agreement_id"
    t.string   "house_type",                   limit: 40
    t.boolean  "breed_restriction"
    t.boolean  "weight_restriction"
    t.boolean  "has_own_dogs"
    t.boolean  "has_own_cats"
    t.boolean  "children_under_five"
    t.boolean  "has_fenced_yard"
    t.boolean  "can_foster_puppies"
    t.boolean  "parvo_house"
    t.text     "admin_comment"
    t.boolean  "is_photographer",                                        default: false
    t.boolean  "writes_newsletter",                                      default: false
    t.boolean  "is_transporter",                                         default: false
    t.integer  "mentor_id"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "dl_locked_resources",                                    default: false
    t.boolean  "training_team",                                          default: false
    t.integer  "confidentiality_agreement_id"
    t.boolean  "foster_mentor",                                          default: false
    t.boolean  "public_relations",                                       default: false
    t.boolean  "fundraising",                                            default: false
    t.boolean  "translator",                                             default: false, null: false
    t.string   "known_languages",              limit: 255
    t.integer  "code_of_conduct_agreement_id"
    t.boolean  "boarding_buddies",                                       default: false, null: false
    t.boolean  "medical_behavior_permission",                            default: false
    t.boolean  "social_media_manager",                                   default: false, null: false
    t.boolean  "graphic_design",                                         default: false, null: false
    t.string   "country",                      limit: 3,                                 null: false, comment: "Country as a ISO 3166-1 alpha-3 code"
    t.index ["agreement_id"], name: "index_users_on_agreement_id", using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["latitude", "longitude"], name: "index_users_on_latitude_and_longitude", using: :btree
    t.index ["mentor_id"], name: "index_users_on_mentor_id", using: :btree
    t.index ["name"], name: "index_users_on_name", using: :btree
  end

  create_table "users_teams", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "team_id"
    t.index ["user_id", "team_id"], name: "index_users_teams_on_user_id_and_team_id", unique: true, using: :btree
  end

end
