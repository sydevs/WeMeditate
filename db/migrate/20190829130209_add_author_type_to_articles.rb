class AddAuthorTypeToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :author_type, :integer, default: 0, null: false
  end
end
