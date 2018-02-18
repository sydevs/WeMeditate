class AddThumbnailToMeditation < ActiveRecord::Migration[5.1]
  def change
    remove_column :meditations, :file, :jsonb
    
    reversible do |dir|
      dir.up do
        Meditation.add_translation_fields! image: :jsonb
        Meditation.add_translation_fields! audio: :jsonb
      end

      dir.down do
        remove_column :meditation_translations, :image
        remove_column :meditation_translations, :audio
      end
    end
  end
end
