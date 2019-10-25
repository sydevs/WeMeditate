class AddArticleType < ActiveRecord::Migration[5.2]
  def change
    rename_column :articles, :author_type, :article_type
  end
end
