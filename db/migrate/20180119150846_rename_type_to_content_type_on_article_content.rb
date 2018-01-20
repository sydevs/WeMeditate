class RenameTypeToContentTypeOnArticleContent < ActiveRecord::Migration[5.1]
  def change
    rename_column :article_contents, :type, :content_type
  end
end
