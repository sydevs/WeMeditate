class AddDraftToSubtleSystemNode < ActiveRecord::Migration[5.2]
  def change
    add_column :subtle_system_node_translations, :draft, :json
  end
end
