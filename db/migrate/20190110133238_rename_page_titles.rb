class RenamePageTitles < ActiveRecord::Migration[5.1]
  def change
    rename_column :article_translations, :title, :name
    rename_column :static_page_translations, :title, :name
    rename_column :track_translations, :title, :name
  end
end
