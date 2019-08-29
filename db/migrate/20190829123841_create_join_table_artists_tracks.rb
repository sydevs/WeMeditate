class CreateJoinTableArtistsTracks < ActiveRecord::Migration[5.2]
  def change
    create_join_table :artists, :tracks do |t|
      t.index %i[artist_id track_id]
      t.index %i[track_id artist_id]
    end

    remove_reference :tracks, :artist, index: true
  end
end
