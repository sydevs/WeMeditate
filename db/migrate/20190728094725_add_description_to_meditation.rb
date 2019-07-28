class AddDescriptionToMeditation < ActiveRecord::Migration[5.2]
  def change
    add_column :meditation_translations, :description, :text
  end
end
