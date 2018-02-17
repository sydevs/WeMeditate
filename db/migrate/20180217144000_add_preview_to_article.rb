class AddPreviewToArticle < ActiveRecord::Migration[5.1]
  def self.up
    Article.add_translation_fields! excerpt: :text
    Article.add_translation_fields! banner: :jsonb
    Article.add_translation_fields! thumbnail: :jsonb
  end

  def self.down
    remove_column :article_translations, :excerpt
    remove_column :article_translations, :banner
    remove_column :article_translations, :thumbnail
  end
end
