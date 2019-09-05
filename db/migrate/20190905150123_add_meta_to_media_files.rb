class AddMetaToMediaFiles < ActiveRecord::Migration[5.2]
  def change
    add_column :media_files, :image_meta, :jsonb
  end
end
