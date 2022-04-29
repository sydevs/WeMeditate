class AddPromoPages < ActiveRecord::Migration[6.0]
  def change
    create_table :promo_pages do |t|
      t.string :name
      t.string :slug
      t.date :published_at
      t.references :owner

      t.jsonb :draft
      t.jsonb :content
      t.jsonb :metatags
      t.integer :state, default: 0
      t.string :locale, null: false
      t.timestamps
    end
  end
end
