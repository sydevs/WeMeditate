class RemoveAttachments < ActiveRecord::Migration[5.2]
  def change
    drop_table "attachments", force: :cascade do |t|
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
  end
end
