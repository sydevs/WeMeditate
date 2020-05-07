class AddTimeZoneIdentifierToStreams < ActiveRecord::Migration[6.0]
  def change
    add_column :streams, :time_zone_identifier, :string
    rename_column :streams, :time_zone, :time_zone_offset
  end
end
