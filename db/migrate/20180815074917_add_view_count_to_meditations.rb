class AddViewCountToMeditations < ActiveRecord::Migration[5.1]
  def up
    Meditation.add_translation_fields! views: { type: :integer, null: false, default: 0 }
  end

  def down
    remove_column :meditation_translations, :views
  end
end
