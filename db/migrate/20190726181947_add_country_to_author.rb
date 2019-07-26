class AddCountryToAuthor < ActiveRecord::Migration[5.2]
  def change
    add_column :authors, :country_code, :string, limit: 2, null: false
  end
end
