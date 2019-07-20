class AddOriginalLocale < ActiveRecord::Migration[5.2]
  def change
    [
      Article, StaticPage, SubtleSystemNode, Track, Treatment, Meditation,
      Category, GoalFilter, InstrumentFilter, DurationFilter, MoodFilter,
    ].each do |model|
      add_column model.table_name, :original_locale, :string, limit: 2
      model.update_all(original_locale: 'en')
      change_column_null model.table_name, :original_locale, false
    end
  end
end
