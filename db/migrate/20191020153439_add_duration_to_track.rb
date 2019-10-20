class AddDurationToTrack < ActiveRecord::Migration[5.2]
  def change
    add_column :tracks, :duration, :integer
  end
end
