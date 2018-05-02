class CreateSubtleSystemNodeTable < ActiveRecord::Migration[5.1]
  def change
    create_table :subtle_system_nodes do |t|
      t.integer :role, null: false
      t.timestamps
    end

    add_index :subtle_system_nodes, :role, unique: true

    reversible do |dir|
      dir.up do
        SubtleSystemNode.create_translation_table!({
          name: { type: :string, null: false },
          slug: { type: :string, null: false },
          excerpt: { type: :text, null: false },
        })
      end

      dir.down do
        SubtleSystemNode.drop_translation_table!
      end
    end
  end
end
