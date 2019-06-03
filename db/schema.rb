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

ActiveRecord::Schema.define(version: 2019_04_20_102629) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "article_translations", force: :cascade do |t|
    t.integer "article_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.text "excerpt"
    t.jsonb "metatags"
    t.integer "video_id"
    t.integer "banner_id"
    t.integer "thumbnail_id"
    t.json "draft"
    t.jsonb "content", default: {}
    t.index ["article_id"], name: "index_article_translations_on_article_id"
    t.index ["locale"], name: "index_article_translations_on_locale"
  end

  create_table "articles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id"
    t.integer "priority", default: 0, null: false
    t.datetime "published_at"
    t.date "date"
    t.index ["category_id"], name: "index_articles_on_category_id"
  end

  create_table "artists", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.jsonb "image"
  end

  create_table "attachments", force: :cascade do |t|
    t.string "uuid", null: false
    t.string "name"
    t.integer "size"
    t.integer "usage_count", default: 0
    t.jsonb "file"
    t.string "page_type"
    t.bigint "page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["page_type", "page_id"], name: "index_attachments_on_page_type_and_page_id"
    t.index ["uuid"], name: "index_attachments_on_uuid"
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
    t.string "icon", default: "", null: false
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

  create_table "media_files", force: :cascade do |t|
    t.string "name"
    t.integer "category", default: 0
    t.integer "usage_count", default: 0
    t.jsonb "file"
    t.string "page_type"
    t.bigint "page_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.string "name", null: false
    t.string "slug", null: false
    t.text "excerpt"
    t.jsonb "metatags"
    t.jsonb "video"
    t.integer "views", default: 0, null: false
    t.index ["locale"], name: "index_meditation_translations_on_locale"
    t.index ["meditation_id"], name: "index_meditation_translations_on_meditation_id"
  end

  create_table "meditations", force: :cascade do |t|
    t.bigint "duration_filter_id"
    t.jsonb "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.jsonb "image"
    t.string "icon"
  end

  create_table "mood_filters_tracks", id: false, force: :cascade do |t|
    t.bigint "track_id"
    t.bigint "mood_filter_id"
    t.index ["mood_filter_id"], name: "index_mood_filters_tracks_on_mood_filter_id"
    t.index ["track_id"], name: "index_mood_filters_tracks_on_track_id"
  end

  create_table "section_translations", force: :cascade do |t|
    t.integer "section_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "label"
    t.string "title"
    t.string "subtitle"
    t.text "text"
    t.text "quote"
    t.string "credit"
    t.string "url"
    t.string "action"
    t.jsonb "extra"
    t.json "draft"
    t.index ["locale"], name: "index_section_translations_on_locale"
    t.index ["section_id"], name: "index_section_translations_on_section_id"
  end

  create_table "sections", force: :cascade do |t|
    t.integer "content_type", default: 0
    t.integer "order", default: 0, null: false
    t.integer "visibility_type", default: 0, null: false
    t.string "visibility_countries"
    t.string "page_type"
    t.bigint "page_id"
    t.string "format"
    t.index ["content_type", "format"], name: "index_sections_on_content_type_and_format"
    t.index ["page_type", "page_id"], name: "index_sections_on_page_type_and_page_id"
  end

  create_table "static_page_translations", force: :cascade do |t|
    t.integer "static_page_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.jsonb "metatags"
    t.json "draft"
    t.jsonb "content", default: {}
    t.index ["locale"], name: "index_static_page_translations_on_locale"
    t.index ["static_page_id"], name: "index_static_page_translations_on_static_page_id"
  end

  create_table "static_pages", force: :cascade do |t|
    t.integer "role", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "published_at"
    t.index ["role"], name: "index_static_pages_on_role", unique: true
  end

  create_table "subtle_system_node_translations", force: :cascade do |t|
    t.integer "subtle_system_node_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.text "excerpt", null: false
    t.jsonb "metatags"
    t.json "draft"
    t.jsonb "content", default: {}
    t.index ["locale"], name: "index_subtle_system_node_translations_on_locale"
    t.index ["subtle_system_node_id"], name: "index_subtle_system_node_translations_on_subtle_system_node_id"
  end

  create_table "subtle_system_nodes", force: :cascade do |t|
    t.integer "role", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "published_at"
    t.index ["role"], name: "index_subtle_system_nodes_on_role", unique: true
  end

  create_table "track_translations", force: :cascade do |t|
    t.integer "track_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.index ["locale"], name: "index_track_translations_on_locale"
    t.index ["track_id"], name: "index_track_translations_on_track_id"
  end

  create_table "tracks", force: :cascade do |t|
    t.string "audio", null: false
    t.bigint "artist_id"
    t.index ["artist_id"], name: "index_tracks_on_artist_id"
  end

  create_table "treatment_translations", force: :cascade do |t|
    t.integer "treatment_id", null: false
    t.string "locale", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.text "excerpt", null: false
    t.jsonb "thumbnail"
    t.jsonb "video"
    t.jsonb "metatags"
    t.jsonb "content", default: {}
    t.index ["locale"], name: "index_treatment_translations_on_locale"
    t.index ["treatment_id"], name: "index_treatment_translations_on_treatment_id"
  end

  create_table "treatments", force: :cascade do |t|
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "articles", "categories"
end
