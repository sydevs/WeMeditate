class AddStreams < ActiveRecord::Migration[6.0]
  def change
    create_table :streams do |t|
      t.string :name
      t.string :slug
      t.integer :thumbnail_id
      t.string :excerpt
      t.date :published_at

      t.string :location
      t.string :time_zone
      t.string :stream_url
      t.string :klaviyo_list_id

      t.date :start_date
      t.string :start_time
      t.string :end_time
      t.integer :recurrence, default: [], null: false, array: true
      t.integer :target_time_zones, default: [], null: false, array: true

      t.jsonb :draft
      t.jsonb :content
      t.jsonb :metatags
      t.integer :state, default: 0
      t.string :locale, null: false
      t.timestamps
    end
  end
end
