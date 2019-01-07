class RemoveVenues < ActiveRecord::Migration[5.1]
  def change
    remove_column :cities, :venues, :jsonb
  end
end
