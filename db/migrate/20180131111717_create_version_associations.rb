# This migration and AddTransactionIdColumnToVersions provide the necessary
# schema for tracking associations.
class CreateVersionAssociations < ActiveRecord::Migration[5.1]
  # The largest text column available in all supported RDBMS.
  # See `create_versions.rb` for details.
  TEXT_BYTES = 1_073_741_823

  def change
    create_table :version_associations do |t|
      t.integer  :version_id
      t.string   :foreign_key_name, null: false
      t.integer  :foreign_key_id
    end

    add_index :version_associations, [:version_id]
    add_index :version_associations,
      %i(foreign_key_name foreign_key_id),
      name: "index_version_associations_on_foreign_key"

    # With changes
    add_column :versions, :object_changes, :text, limit: TEXT_BYTES

    # With associations
    add_column :versions, :transaction_id, :integer
    add_index :versions, [:transaction_id]
  end
end
