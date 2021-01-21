class AddTableOfContentsToArticles < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :table_of_contents, :boolean, null: false, default: false
  end
end
