class CreateMediaFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :media_files do |t|
      t.string :name
      t.integer :category, default: 0
      t.integer :usage_count, default: 0
      t.jsonb :file
      t.references :page, polymorphic: true, index: true
      t.timestamps
    end

    # Fix the articles schema for the new upload system
    remove_column :articles, :video_uuid, :string
    remove_column :article_translations, :banner_uuid, :string
    remove_column :article_translations, :thumbnail_uuid, :string
    add_column :article_translations, :video_id, :integer
    add_column :article_translations, :banner_id, :integer
    add_column :article_translations, :thumbnail_id, :integer

    # Fix the cities schema
    remove_column :cities, :banner_uuid, :string
    add_column :cities, :banner_id, :integer

    # Remove attachments table
=begin
    drop_table :attachments do |t|
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
=end
  end
end
