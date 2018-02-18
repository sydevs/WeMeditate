class AdjustTracks < ActiveRecord::Migration[5.1]
  def change
    rename_column :tracks, :file, :audio
    add_column :mood_filters, :image, :jsonb
  end
end
