class AddTimestampsToTracks < ActiveRecord::Migration[5.2]
  def change
    add_column :tracks, :created_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    add_column :tracks, :updated_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    change_column_default :tracks, :created_at, from: -> { 'CURRENT_TIMESTAMP' }, to: nil
    change_column_default :tracks, :updated_at, from: -> { 'CURRENT_TIMESTAMP' }, to: nil
  end
end
