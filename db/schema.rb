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

ActiveRecord::Schema.define(version: 2021_01_22_000453) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "article_translations", force: :cascade do |t|
    t.integer "article_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "slug"
    t.text "excerpt"
    t.jsonb "metatags"
    t.integer "thumbnail_id"
    t.jsonb "draft"
    t.jsonb "content"
    t.integer "vimeo_id"
    t.datetime "published_at"
    t.integer "banner_id"
    t.integer "state", default: 0
    t.integer "priority", default: 0, null: false
    t.bigint "order", default: 0, null: false
    t.index ["article_id"], name: "index_article_translations_on_article_id"
    t.index ["locale"], name: "index_article_translations_on_locale"
  end

  create_table "articles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id"
    t.date "date"
    t.bigint "owner_id"
    t.string "original_locale", null: false
    t.bigint "author_id"
    t.integer "article_type", default: 0, null: false
    t.float "latitude"
    t.float "longitude"
    t.boolean "table_of_contents", default: false, null: false
    t.integer "table_of_contents_position"
    t.index ["author_id"], name: "index_articles_on_author_id"
    t.index ["category_id"], name: "index_articles_on_category_id"
    t.index ["owner_id"], name: "index_articles_on_owner_id"
  end

  create_table "artists", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.jsonb "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "artists_tracks", id: false, force: :cascade do |t|
    t.bigint "artist_id", null: false
    t.bigint "track_id", null: false
    t.index ["artist_id", "track_id"], name: "index_artists_tracks_on_artist_id_and_track_id"
    t.index ["track_id", "artist_id"], name: "index_artists_tracks_on_track_id_and_artist_id"
  end

  create_table "audits", force: :cascade do |t|
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
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "author_translations", force: :cascade do |t|
    t.bigint "author_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "description"
    t.datetime "published_at"
    t.integer "state", default: 0
    t.string "name"
    t.index ["author_id"], name: "index_author_translations_on_author_id"
    t.index ["locale"], name: "index_author_translations_on_locale"
  end

  create_table "authors", force: :cascade do |t|
    t.integer "years_meditating"
    t.jsonb "image"
    t.bigint "user_id"
    t.string "original_locale", limit: 2, null: false
    t.string "country_code", limit: 2, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["user_id"], name: "index_authors_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "original_locale", null: false
  end

  create_table "category_translations", force: :cascade do |t|
    t.integer "category_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.boolean "published", default: false
    t.datetime "published_at"
    t.index ["category_id"], name: "index_category_translations_on_category_id"
    t.index ["locale"], name: "index_category_translations_on_locale"
  end

  create_table "duration_filter_translations", force: :cascade do |t|
    t.bigint "duration_filter_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "published"
    t.datetime "published_at"
    t.index ["duration_filter_id"], name: "index_duration_filter_translations_on_duration_filter_id"
    t.index ["locale"], name: "index_duration_filter_translations_on_locale"
  end

  create_table "duration_filters", force: :cascade do |t|
    t.integer "minutes"
    t.string "original_locale", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
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
    t.string "name"
    t.boolean "published", default: false
    t.datetime "published_at"
    t.index ["goal_filter_id"], name: "index_goal_filter_translations_on_goal_filter_id"
    t.index ["locale"], name: "index_goal_filter_translations_on_locale"
  end

  create_table "goal_filters", force: :cascade do |t|
    t.integer "order"
    t.string "icon", default: "", null: false
    t.string "original_locale", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
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
    t.string "name"
    t.boolean "published", default: false
    t.datetime "published_at"
    t.index ["instrument_filter_id"], name: "index_instrument_filter_translations_on_instrument_filter_id"
    t.index ["locale"], name: "index_instrument_filter_translations_on_locale"
  end

  create_table "instrument_filters", force: :cascade do |t|
    t.string "icon", null: false
    t.integer "order"
    t.string "original_locale", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "instrument_filters_tracks", id: false, force: :cascade do |t|
    t.bigint "track_id"
    t.bigint "instrument_filter_id"
    t.index ["instrument_filter_id"], name: "index_instrument_filters_tracks_on_instrument_filter_id"
    t.index ["track_id"], name: "index_instrument_filters_tracks_on_track_id"
  end

  create_table "media_files", force: :cascade do |t|
    t.jsonb "file"
    t.string "page_type"
    t.bigint "page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "image_meta"
    t.index ["page_type", "page_id"], name: "index_media_files_on_page_type_and_page_id"
  end

  create_table "media_files_pages", force: :cascade do |t|
    t.bigint "media_file_id"
    t.string "page_type"
    t.bigint "page_id"
    t.index ["media_file_id"], name: "index_media_files_pages_on_media_file_id"
    t.index ["page_type", "page_id"], name: "index_media_files_pages_on_page_type_and_page_id"
  end

  create_table "meditation_translations", force: :cascade do |t|
    t.integer "meditation_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "slug"
    t.text "excerpt"
    t.jsonb "metatags"
    t.integer "views", default: 0, null: false
    t.integer "horizontal_vimeo_id"
    t.integer "vertical_vimeo_id"
    t.datetime "published_at"
    t.text "description"
    t.float "popularity", default: 0.0, null: false
    t.jsonb "vimeo_metadata"
    t.integer "state", default: 0
    t.jsonb "draft"
    t.integer "thumbnail_id"
    t.index ["locale"], name: "index_meditation_translations_on_locale"
    t.index ["meditation_id"], name: "index_meditation_translations_on_meditation_id"
  end

  create_table "meditations", force: :cascade do |t|
    t.bigint "duration_filter_id"
    t.jsonb "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "original_locale", null: false
    t.index ["duration_filter_id"], name: "index_meditations_on_duration_filter_id"
  end

  create_table "mood_filter_translations", force: :cascade do |t|
    t.integer "mood_filter_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.boolean "published", default: false
    t.datetime "published_at"
    t.index ["locale"], name: "index_mood_filter_translations_on_locale"
    t.index ["mood_filter_id"], name: "index_mood_filter_translations_on_mood_filter_id"
  end

  create_table "mood_filters", force: :cascade do |t|
    t.integer "order"
    t.jsonb "image"
    t.string "icon"
    t.string "original_locale", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "mood_filters_tracks", id: false, force: :cascade do |t|
    t.bigint "track_id"
    t.bigint "mood_filter_id"
    t.index ["mood_filter_id"], name: "index_mood_filters_tracks_on_mood_filter_id"
    t.index ["track_id"], name: "index_mood_filters_tracks_on_track_id"
  end

  create_table "static_page_translations", force: :cascade do |t|
    t.integer "static_page_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "slug"
    t.jsonb "metatags"
    t.jsonb "draft"
    t.jsonb "content"
    t.datetime "published_at"
    t.integer "state", default: 0
    t.index ["locale"], name: "index_static_page_translations_on_locale"
    t.index ["static_page_id"], name: "index_static_page_translations_on_static_page_id"
  end

  create_table "static_pages", force: :cascade do |t|
    t.integer "role", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "original_locale", null: false
    t.index ["role"], name: "index_static_pages_on_role"
  end

  create_table "streams", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.integer "thumbnail_id"
    t.string "excerpt"
    t.date "published_at"
    t.string "location"
    t.string "stream_url"
    t.date "start_date"
    t.string "start_time"
    t.string "end_time"
    t.integer "recurrence", default: [], null: false, array: true
    t.integer "target_time_zones", default: [], null: false, array: true
    t.jsonb "draft"
    t.jsonb "content"
    t.jsonb "metatags"
    t.integer "state", default: 0
    t.string "locale", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "time_zone_offset"
    t.string "time_zone_identifier"
    t.string "video_conference_url"
  end

  create_table "subtle_system_node_translations", force: :cascade do |t|
    t.integer "subtle_system_node_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "slug"
    t.text "excerpt"
    t.jsonb "metatags"
    t.jsonb "draft"
    t.jsonb "content"
    t.datetime "published_at"
    t.integer "state", default: 0
    t.index ["locale"], name: "index_subtle_system_node_translations_on_locale"
    t.index ["subtle_system_node_id"], name: "index_subtle_system_node_translations_on_subtle_system_node_id"
  end

  create_table "subtle_system_nodes", force: :cascade do |t|
    t.integer "role", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "original_locale", null: false
    t.index ["role"], name: "index_subtle_system_nodes_on_role", unique: true
  end

  create_table "track_translations", force: :cascade do |t|
    t.integer "track_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.boolean "published", default: false
    t.datetime "published_at"
    t.index ["locale"], name: "index_track_translations_on_locale"
    t.index ["track_id"], name: "index_track_translations_on_track_id"
  end

  create_table "tracks", force: :cascade do |t|
    t.string "audio", null: false
    t.string "original_locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "duration"
  end

  create_table "treatment_translations", force: :cascade do |t|
    t.integer "treatment_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "slug"
    t.text "excerpt"
    t.jsonb "metatags"
    t.jsonb "content"
    t.integer "horizontal_vimeo_id"
    t.integer "vertical_vimeo_id"
    t.datetime "published_at"
    t.jsonb "draft"
    t.integer "thumbnail_id"
    t.integer "state", default: 0
    t.index ["locale"], name: "index_treatment_translations_on_locale"
    t.index ["treatment_id"], name: "index_treatment_translations_on_treatment_id"
  end

  create_table "treatments", force: :cascade do |t|
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "original_locale", null: false
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
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.string "name"
    t.string "languages_access", default: [], null: false, array: true
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "languages_known", default: [], null: false, array: true
    t.string "preferred_language"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["languages_access"], name: "index_users_on_languages_access", using: :gin
    t.index ["languages_known"], name: "index_users_on_languages_known", using: :gin
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "articles", "categories"
end
