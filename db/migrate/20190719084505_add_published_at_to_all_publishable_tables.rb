class AddPublishedAtToAllPublishableTables < ActiveRecord::Migration[5.2]
  def change
    %i[
      static_page subtle_system_node track treatment meditation
      category goal_filter instrument_filter duration_filter mood_filter
    ].each do |table|
      add_column "#{table}_translations", :published_at, :datetime
    end
  end
end
