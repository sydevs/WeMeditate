class AddTimestampsToArtists < ActiveRecord::Migration[6.0]

  def change
    add_column :artists, :created_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    add_column :artists, :updated_at, :datetime, null: false, default: -> { 'CURRENT_TIMESTAMP' }
    change_column_default :artists, :created_at, from: -> { 'CURRENT_TIMESTAMP' }, to: nil
    change_column_default :artists, :updated_at, from: -> { 'CURRENT_TIMESTAMP' }, to: nil
  end

end
