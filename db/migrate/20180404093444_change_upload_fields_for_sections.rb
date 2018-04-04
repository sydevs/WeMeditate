class ChangeUploadFieldsForSections < ActiveRecord::Migration[5.1]
  def change
    remove_column :section_translations, :image, :jsonb, null: false
    remove_column :section_translations, :video, :jsonb, null: false

    reversible do |dir|
      dir.up do
        Section.add_translation_fields! images: :jsonb
        Section.add_translation_fields! videos: :jsonb
      end

      dir.down do
        remove_column :section_translations, :images
        remove_column :section_translations, :videos
      end
    end
  end
end
