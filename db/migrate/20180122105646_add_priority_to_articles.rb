class AddPriorityToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :priority, :integer, default: 0, null: false
  end
end
