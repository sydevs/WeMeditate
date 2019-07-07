class RemoveSections < ActiveRecord::Migration[5.2]
  def change
    drop_table :sections
    drop_table :section_translations
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
