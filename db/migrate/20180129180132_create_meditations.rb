class CreateMeditations < ActiveRecord::Migration[5.1]
  def change
    create_table :meditations do |t|
      t.string :file, null: false
      t.belongs_to :duration_filters
    end

    create_table :goal_filters do |t|
      t.integer :order
    end

    create_table :duration_filters do |t|
      t.integer :order
    end

    create_table :goal_filters_meditations, id: false do |t|
      t.belongs_to :meditation, index: true
      t.belongs_to :goal_filter, index: true
    end

    reversible do |dir|
      dir.up do
        GoalFilter.create_translation_table!({
          name: { type: :string, null: false }
        })
        
        DurationFilter.create_translation_table!({
          name: { type: :string, null: false }
        })
        
        Meditation.create_translation_table!({
          name: { type: :string, null: false },
        })
      end

      dir.down do
        GoalFilter.drop_translation_table!
        DurationFilter.drop_translation_table!
        Meditation.drop_translation_table!
      end
    end
  end
end
