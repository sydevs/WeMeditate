class AddIconToGoalFilters < ActiveRecord::Migration[5.1]
  def change
    add_column :goal_filters, :icon, :string, null: false, default: ''
  end
end
