class SimplifyMediaFile < ActiveRecord::Migration[5.2]
  def change
    remove_column :media_files, :name, :string
    remove_column :media_files, :category, :integer, default: 0
    remove_column :media_files, :usage_count, :integer, default: 0
  end
end
