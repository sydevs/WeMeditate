class AddComputedOrderToArticles < ActiveRecord::Migration[5.2]
  def change
    remove_column :articles, :priority, :integer, default: 0, null: false
    add_column :article_translations, :priority, :integer, default: 0, null: false
    add_column :article_translations, :order, :integer, limit: 8, default: 0, null: false
  end
end
