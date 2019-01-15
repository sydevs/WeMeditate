class AddTimestampsToTreatments < ActiveRecord::Migration[5.1]
  def change
    add_column :treatments, :created_at, :datetime, null: false
    add_column :treatments, :updated_at, :datetime, null: false
  end
end
