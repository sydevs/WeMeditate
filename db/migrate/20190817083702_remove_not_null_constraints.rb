class RemoveNotNullConstraints < ActiveRecord::Migration[5.2]
  def change
    change_column_null :article_translations, :name, true
    change_column_null :article_translations, :slug, true
    change_column_null :goal_filter_translations, :name, true
    change_column_null :instrument_filter_translations, :name, true
    change_column_null :meditation_translations, :name, true
    change_column_null :meditation_translations, :slug, true
    change_column_null :mood_filter_translations, :name, true
    change_column_null :static_page_translations, :name, true
    change_column_null :static_page_translations, :slug, true
    change_column_null :subtle_system_node_translations, :name, true
    change_column_null :subtle_system_node_translations, :slug, true
    change_column_null :subtle_system_node_translations, :excerpt, true
    change_column_null :track_translations, :name, true
    change_column_null :treatment_translations, :name, true
    change_column_null :treatment_translations, :slug, true
    change_column_null :treatment_translations, :excerpt, true
  end
end
