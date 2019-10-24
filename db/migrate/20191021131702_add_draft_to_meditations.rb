class AddDraftToMeditations < ActiveRecord::Migration[5.2]
  def change
    add_column :meditation_translations, :draft, :jsonb
    add_column :meditation_translations, :thumbnail_id, :integer
  end
end
