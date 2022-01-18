class AddAudioMediaFiles < ActiveRecord::Migration[6.0]

  def change
    rename_column :media_files, :image_meta, :meta
    add_column :media_files, :mime_type, :string
  end

end
