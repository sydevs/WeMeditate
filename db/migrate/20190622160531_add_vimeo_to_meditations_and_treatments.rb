class AddVimeoToMeditationsAndTreatments < ActiveRecord::Migration[5.2]
  def change
    remove_column :meditation_translations, :video, :jsonb
    remove_column :treatment_translations, :video, :jsonb
    remove_column :article_translations, :video_id, :integer

    add_column :meditation_translations, :horizontal_vimeo_id, :integer
    add_column :meditation_translations, :vertical_vimeo_id, :integer
    add_column :treatment_translations, :horizontal_vimeo_id, :integer
    add_column :treatment_translations, :vertical_vimeo_id, :integer
    add_column :article_translations, :vimeo_id, :integer
  end
end
