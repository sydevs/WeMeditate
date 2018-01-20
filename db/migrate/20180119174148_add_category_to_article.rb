class AddCategoryToArticle < ActiveRecord::Migration[5.1]
  def change
    add_reference :articles, :category, foreign_key: true
  end
end
