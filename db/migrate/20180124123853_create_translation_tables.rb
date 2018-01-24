class CreateTranslationTables < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      dir.up do
        Article.create_translation_table!({
          title: { type: :string, null: false },
          slug: { type: :string, null: false }
        })

        Category.create_translation_table!({
          name: { type: :string, null: false },
          slug: { type: :string, null: false }
        })

        InstrumentFilter.create_translation_table!({
          name: { type: :string, null: false }
        })
        
        MoodFilter.create_translation_table!({
          name: { type: :string, null: false }
        })
        
        Track.create_translation_table!({
          title: { type: :string, null: false },
          subtitle: { type: :string }
        })
      end

      dir.down do
        Article.drop_translation_table!
        Category.drop_translation_table!
        InstrumentFilter.drop_translation_table!
        MoodFilter.drop_translation_table!
        Track.drop_translation_table!
      end
    end

    remove_column :articles, :title, :string
    remove_column :articles, :slug, :string, null: false
    remove_column :categories, :name, :string
    remove_column :categories, :slug, :string, null: false
    remove_column :instrument_filters, :name, :string
    remove_column :mood_filters, :name, :string
    remove_column :tracks, :title, :string, null: false
    remove_column :tracks, :subtitle, :string
  end
end
