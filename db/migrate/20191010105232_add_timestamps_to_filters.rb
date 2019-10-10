class AddTimestampsToFilters < ActiveRecord::Migration[5.2]
  def change
    %i[duration_filters instrument_filters goal_filters mood_filters authors].each do |table|
      add_column table, :created_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      add_column table, :updated_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    end
  end
end
