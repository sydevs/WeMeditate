class AddPublishAtToPages < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :published_at, :datetime
    add_column :cities, :published_at, :datetime
    add_column :static_pages, :published_at, :datetime
  end
end
