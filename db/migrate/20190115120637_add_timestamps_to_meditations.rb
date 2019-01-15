class AddTimestampsToMeditations < ActiveRecord::Migration[5.1]
  def change
    add_column :meditations, :created_at, :datetime, null: false
    add_column :meditations, :updated_at, :datetime, null: false
  end
end
