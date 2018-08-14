class CreateMeta < ActiveRecord::Migration[5.1]
  def up
    Article.add_translation_fields! metatags: :jsonb
    City.add_translation_fields! metatags: :jsonb
    Meditation.add_translation_fields! metatags: :jsonb
    StaticPage.add_translation_fields! metatags: :jsonb
    SubtleSystemNode.add_translation_fields! metatags: :jsonb
    Treatment.add_translation_fields! metatags: :jsonb
  end

  def down
    remove_column :article_translations, :metatags
    remove_column :city_translations, :metatags
    remove_column :meditation_translations, :metatags
    remove_column :static_page_translations, :metatags
    remove_column :subtle_system_node_translations, :metatags
    remove_column :treatment_translations, :metatags
  end
end
