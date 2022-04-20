class AddSettingsToCategories < ActiveRecord::Migration[6.0]
  def change
    add_column :categories, :show_articles_in_header, :boolean, default: false
    add_column :categories, :show_articles_in_index, :boolean, default: true
  end
end
