class AddPublishedAtToSubtleSystemNodes < ActiveRecord::Migration[5.2]
  def change
    add_column :subtle_system_nodes, :published_at, :datetime
  end
end
