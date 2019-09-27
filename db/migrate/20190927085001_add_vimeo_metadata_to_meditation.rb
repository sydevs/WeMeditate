class AddVimeoMetadataToMeditation < ActiveRecord::Migration[5.2]
  def change
    add_column :meditation_translations, :vimeo_metadata, :jsonb
  end
end
