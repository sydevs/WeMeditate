class RemoveTableOfContents < ActiveRecord::Migration[6.0]
  def change
    remove_column :articles, :table_of_contents, :boolean, null: false, default: false
    remove_column :articles, :table_of_contents_position, :integer
  end
end
