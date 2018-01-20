class RenameArticleContents < ActiveRecord::Migration[5.1]
  def change
    rename_table :article_contents, :sections
  end
end
