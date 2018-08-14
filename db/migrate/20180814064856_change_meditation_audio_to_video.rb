class ChangeMeditationAudioToVideo < ActiveRecord::Migration[5.1]
  def up
    remove_column :meditation_translations, :audio
    Meditation.add_translation_fields! video: :jsonb
  end

  def down
    remove_column :meditation_translations, :video
    Meditation.add_translation_fields! audio: :jsonb
  end
end
