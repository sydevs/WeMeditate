class AddImagesToSections < ActiveRecord::Migration[5.1]
  def change
    add_column :sections, :images, :jsonb
  end
end
