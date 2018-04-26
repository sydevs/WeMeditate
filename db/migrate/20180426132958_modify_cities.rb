class ModifyCities < ActiveRecord::Migration[5.1]
  def change
    remove_column :cities, :address, :string
    add_column :cities, :venues, :jsonb
    add_column :cities, :country, :integer
  end
end
