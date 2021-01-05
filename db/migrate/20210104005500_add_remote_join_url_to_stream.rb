class AddRemoteJoinUrlToStream < ActiveRecord::Migration[6.0]
  def change
    add_column :streams, :video_conference_url, :string, default: nil
  end
end
