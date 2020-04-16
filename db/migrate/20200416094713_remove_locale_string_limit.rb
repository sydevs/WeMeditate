class RemoveLocaleStringLimit < ActiveRecord::Migration[6.0]
  def change
    [
      Article, StaticPage, SubtleSystemNode, Track, Treatment, Meditation,
      Category, GoalFilter, InstrumentFilter, DurationFilter, MoodFilter,
    ].each do |model|
      change_column model.table_name, :original_locale, :string, limit: nil
    end
  end
end
