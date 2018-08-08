class AddDescriptionToMeditations < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      dir.up do
        Meditation.add_translation_fields! excerpt: :text
      end

      dir.down do
        remove_column :meditation_translations, :excerpt
      end
    end
  end
end
