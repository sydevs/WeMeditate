class RemoveRoleUniqueConstraintFromStaticPages < ActiveRecord::Migration[6.0]
  def up
    remove_index :static_pages, :role
    add_index :static_pages, :role
  end

  def down
    remove_index :static_pages, :role
    add_index :static_pages, :role, unique: true
  end
end
