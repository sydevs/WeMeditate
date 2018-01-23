class CreateTracks < ActiveRecord::Migration[5.1]
  def change
    create_table :tracks do |t|
      t.string :title, null: false
      t.string :subtitle
      t.string :file, null: false
      t.integer :mood, default: 0, null: false
      t.string :instruments
    end
  end
end
