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

ActiveRecord::Schema.define(version: 20180130114319) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "article_translations", force: :cascade do |t|
    t.integer "article_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", null: false
    t.string "slug", null: false
    t.index ["article_id"], name: "index_article_translations_on_article_id"
    t.index ["locale"], name: "index_article_translations_on_locale"
  end

  create_table "articles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id"
    t.integer "priority", default: 0, null: false
    t.integer "draft_id"
    t.datetime "published_at"
    t.datetime "trashed_at"
    t.index ["category_id"], name: "index_articles_on_category_id"
  end

  create_table "categories", force: :cascade do |t|
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "category_translations", force: :cascade do |t|
    t.integer "category_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.index ["category_id"], name: "index_category_translations_on_category_id"
    t.index ["locale"], name: "index_category_translations_on_locale"
  end

  create_table "cities", force: :cascade do |t|
    t.float "latitude", null: false
    t.float "longitude", null: false
    t.string "banner", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address"
    t.integer "draft_id"
    t.datetime "published_at"
    t.datetime "trashed_at"
  end

  create_table "city_translations", force: :cascade do |t|
    t.integer "city_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.index ["city_id"], name: "index_city_translations_on_city_id"
    t.index ["locale"], name: "index_city_translations_on_locale"
  end

  create_table "duration_filters", force: :cascade do |t|
    t.integer "minutes"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.string "locale"
    t.index ["locale"], name: "index_friendly_id_slugs_on_locale"
    t.index ["slug", "sluggable_type", "locale"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_locale"
    t.index ["slug", "sluggable_type", "scope", "locale"], name: "index_friendly_id_slugs_uniqueness", unique: true
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "goal_filter_translations", force: :cascade do |t|
    t.integer "goal_filter_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.index ["goal_filter_id"], name: "index_goal_filter_translations_on_goal_filter_id"
    t.index ["locale"], name: "index_goal_filter_translations_on_locale"
  end

  create_table "goal_filters", force: :cascade do |t|
    t.integer "order"
  end

  create_table "goal_filters_meditations", id: false, force: :cascade do |t|
    t.bigint "meditation_id"
    t.bigint "goal_filter_id"
    t.index ["goal_filter_id"], name: "index_goal_filters_meditations_on_goal_filter_id"
    t.index ["meditation_id"], name: "index_goal_filters_meditations_on_meditation_id"
  end

  create_table "instrument_filter_translations", force: :cascade do |t|
    t.integer "instrument_filter_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.index ["instrument_filter_id"], name: "index_instrument_filter_translations_on_instrument_filter_id"
    t.index ["locale"], name: "index_instrument_filter_translations_on_locale"
  end

  create_table "instrument_filters", force: :cascade do |t|
    t.string "icon", null: false
    t.integer "order"
  end

  create_table "instrument_filters_tracks", id: false, force: :cascade do |t|
    t.bigint "track_id"
    t.bigint "instrument_filter_id"
    t.index ["instrument_filter_id"], name: "index_instrument_filters_tracks_on_instrument_filter_id"
    t.index ["track_id"], name: "index_instrument_filters_tracks_on_track_id"
  end

  create_table "meditation_translations", force: :cascade do |t|
    t.integer "meditation_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.index ["locale"], name: "index_meditation_translations_on_locale"
    t.index ["meditation_id"], name: "index_meditation_translations_on_meditation_id"
  end

  create_table "meditations", force: :cascade do |t|
    t.string "file", null: false
    t.bigint "duration_filter_id"
    t.index ["duration_filter_id"], name: "index_meditations_on_duration_filter_id"
  end

  create_table "mood_filter_translations", force: :cascade do |t|
    t.integer "mood_filter_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.index ["locale"], name: "index_mood_filter_translations_on_locale"
    t.index ["mood_filter_id"], name: "index_mood_filter_translations_on_mood_filter_id"
  end

  create_table "mood_filters", force: :cascade do |t|
    t.integer "order"
  end

  create_table "mood_filters_tracks", id: false, force: :cascade do |t|
    t.bigint "track_id"
    t.bigint "mood_filter_id"
    t.index ["mood_filter_id"], name: "index_mood_filters_tracks_on_mood_filter_id"
    t.index ["track_id"], name: "index_mood_filters_tracks_on_track_id"
  end

  create_table "program_times", force: :cascade do |t|
    t.integer "day_of_week"
    t.time "start_time"
    t.time "end_time"
    t.bigint "program_venue_id"
    t.index ["program_venue_id"], name: "index_program_times_on_program_venue_id"
  end

  create_table "program_venues", force: :cascade do |t|
    t.string "address"
    t.string "room_information"
    t.json "program_times"
    t.integer "order"
    t.float "latitude"
    t.float "longitude"
    t.bigint "city_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_program_venues_on_city_id"
  end

  create_table "sections", force: :cascade do |t|
    t.string "header"
    t.integer "content_type", default: 0
    t.integer "order", default: 0, null: false
    t.jsonb "parameters", default: {}, null: false
    t.integer "visibility_type", default: 0, null: false
    t.string "visibility_countries"
    t.integer "language", default: 0, null: false
    t.string "page_type"
    t.bigint "page_id"
    t.jsonb "images"
    t.index ["page_type", "page_id"], name: "index_sections_on_page_type_and_page_id"
  end

  create_table "static_page_translations", force: :cascade do |t|
    t.integer "static_page_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", null: false
    t.string "slug", null: false
    t.index ["locale"], name: "index_static_page_translations_on_locale"
    t.index ["static_page_id"], name: "index_static_page_translations_on_static_page_id"
  end

  create_table "static_pages", force: :cascade do |t|
    t.integer "role", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role"], name: "index_static_pages_on_role", unique: true
  end

  create_table "track_translations", force: :cascade do |t|
    t.integer "track_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", null: false
    t.string "subtitle"
    t.index ["locale"], name: "index_track_translations_on_locale"
    t.index ["track_id"], name: "index_track_translations_on_track_id"
  end

  create_table "tracks", force: :cascade do |t|
    t.string "file", null: false
  end

  create_table "treatment_translations", force: :cascade do |t|
    t.integer "treatment_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.text "excerpt", null: false
    t.text "content"
    t.index ["locale"], name: "index_treatment_translations_on_locale"
    t.index ["treatment_id"], name: "index_treatment_translations_on_treatment_id"
  end

  create_table "treatments", force: :cascade do |t|
    t.string "video_url"
    t.integer "order"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.integer "role", default: 0
    t.string "languages"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "articles", "categories"
end
