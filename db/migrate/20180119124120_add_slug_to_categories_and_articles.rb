class AddSlugToCategoriesAndArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :slug, :string, null: false
    add_column :articles, :slug, :string, null: false
  end
end
