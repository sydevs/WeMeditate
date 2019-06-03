class RemoveCities < ActiveRecord::Migration[5.2]

  def change
    drop_table 'cities', force: :cascade do |t|
      t.float 'latitude', null: false
      t.float 'longitude', null: false
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.datetime 'published_at'
      t.integer 'country'
      t.jsonb 'contacts'
      t.integer 'banner_id'
    end

    drop_table 'city_translations', force: :cascade do |t|
      t.integer 'city_id', null: false
      t.string 'locale', null: false
      t.datetime 'created_at', null: false
      t.datetime 'updated_at', null: false
      t.string 'name', null: false
      t.string 'slug', null: false
      t.jsonb 'metatags'
      t.index ['city_id'], name: 'index_city_translations_on_city_id'
      t.index ['locale'], name: 'index_city_translations_on_locale'
    end
  end

end
