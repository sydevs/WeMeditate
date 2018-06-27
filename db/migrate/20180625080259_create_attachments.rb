class CreateAttachments < ActiveRecord::Migration[5.1]
  def change
    create_table :attachments do |t|
      t.string :uuid, null: false, index: true
      t.string :name
      t.integer :size
      t.integer :usage_count, default: 0
      t.jsonb :file
      t.references :page, polymorphic: true, index: true
      t.timestamps
    end

    reversible do |dir|
      dir.up do
        remove_column :article_translations, :banner, :jsonb
        remove_column :article_translations, :thumbnail, :jsonb
        Article.add_translation_fields!({
          banner_uuid: :string,
          thumbnail_uuid: :string,
        })
      end
      dir.down do
        remove_column :article_translations, :banner_uuid, :string
        remove_column :article_translations, :thumbnail_uuid, :string
        Article.add_translation_fields!({
          banner: :jsonb,
          thumbnail: :jsonb,
        })
      end
    end

    remove_column :cities, :banner, :jsonb
    add_column :cities, :banner_uuid, :string

    remove_column :section_translations, :sidetext, :string, null: false
    remove_column :section_translations, :images, :jsonb, null: false
    remove_column :section_translations, :videos, :jsonb, null: false
  end
end
