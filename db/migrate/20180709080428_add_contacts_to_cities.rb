class AddContactsToCities < ActiveRecord::Migration[5.1]
  def change
    add_column :cities, :contacts, :jsonb
  end
end
