class AddTableOfContentsPositionToArticles < ActiveRecord::Migration[6.0]
  def change
    add_column :articles, :table_of_contents_position, :integer
  end
end
