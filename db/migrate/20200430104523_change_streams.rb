class ChangeStreams < ActiveRecord::Migration[6.0]
  def change
    remove_column :streams, :klaviyo_list_id, :string
    remove_column :streams, :time_zone, :string
    add_column :streams, :time_zone, :integer
  end
end
