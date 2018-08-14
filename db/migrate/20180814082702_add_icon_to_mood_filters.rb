class AddIconToMoodFilters < ActiveRecord::Migration[5.1]
  def change
    add_column :mood_filters, :icon, :string
  end
end
