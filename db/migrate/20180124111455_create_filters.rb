class CreateFilters < ActiveRecord::Migration[5.1]
  def change
    create_table :mood_filters do |t|
      t.string :name, null: false
      t.integer :order
    end

    create_table :instrument_filters do |t|
      t.string :name, null: false
      t.string :icon, null: false
      t.integer :order
    end

    remove_column :tracks, :mood, :integer, default: 0, null: false
    remove_column :tracks, :instruments, :string

    create_table :mood_filters_tracks, id: false do |t|
      t.belongs_to :track, index: true
      t.belongs_to :mood_filter, index: true
    end

    create_table :instrument_filters_tracks, id: false do |t|
      t.belongs_to :track, index: true
      t.belongs_to :instrument_filter, index: true
    end
  end
end
