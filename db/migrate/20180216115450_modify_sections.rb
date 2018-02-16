class ModifySections < ActiveRecord::Migration[5.1]
  def change
    remove_column :sections, :header, :string
    add_column :sections, :format, :string
    add_index :sections, [:content_type, :format]
  end
end
