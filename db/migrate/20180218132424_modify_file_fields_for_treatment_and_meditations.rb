class ModifyFileFieldsForTreatmentAndMeditations < ActiveRecord::Migration[5.1]
  def change
    add_column :meditations, :image, :jsonb

    reversible do |dir|
      dir.up do
        remove_column :meditation_translations, :image
        Treatment.add_translation_fields! thumbnail: :jsonb
        Treatment.add_translation_fields! video: :jsonb
      end

      dir.down do
        Meditation.add_translation_fields! image: :jsonb
        remove_column :treatment_translations, :thumbnail
        remove_column :treatment_translations, :video
      end
    end
  end
end
