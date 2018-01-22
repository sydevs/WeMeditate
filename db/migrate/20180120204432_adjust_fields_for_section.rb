class AdjustFieldsForSection < ActiveRecord::Migration[5.1]
  def change
    remove_column :sections, :text, :string
    remove_column :sections, :options, :json

    add_column :sections, :order, :integer, default: 0, null: false
    add_column :sections, :parameters, :jsonb, default: {}, null: false
    add_column :sections, :visibility_type, :integer, default: 0, null: false
    add_column :sections, :visibility_countries, :string
    add_column :sections, :language, :integer, default: 0, null: false
  end
end
