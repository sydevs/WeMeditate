class AddSpecialFieldsToSections < ActiveRecord::Migration[5.1]
  def change
    add_column :sections, :special, :jsonb
  end
end
