class CreateArtists < ActiveRecord::Migration[5.1]
  def change
    create_table :artists do |t|
      t.string :name
      t.string :url
      t.jsonb :image
    end

    add_belongs_to :tracks, :artist
    
    reversible do |dir|
      dir.up do
        remove_column :track_translations, :subtitle
      end

      dir.down do
        Track.add_translation_fields! subtitle: :string
      end
    end
  end
end
