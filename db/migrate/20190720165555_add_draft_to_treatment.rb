class AddDraftToTreatment < ActiveRecord::Migration[5.2]
  def change
    add_column :treatment_translations, :draft, :jsonb
    remove_column :treatment_translations, :thumbnail, :jsonb
    add_column :treatment_translations, :thumbnail_id, :integer
    change_column_default :treatment_translations, :content, from: '{}', to: nil
  end
end
