class AddPreviewFieldsToArticles < ActiveRecord::Migration[5.1]
  def change
    add_column :articles, :video_uuid, :string
    add_column :articles, :date, :date
  end
end
