class MakeSectionSpecialAttributesTranslatable < ActiveRecord::Migration[5.1]
  def change
    remove_column :sections, :special, :jsonb

    reversible do |dir|
      dir.up do
        Section.add_translation_fields! extra: :jsonb
      end

      dir.down do
        remove_column :section_translations, :extra
      end
    end
  end
end
