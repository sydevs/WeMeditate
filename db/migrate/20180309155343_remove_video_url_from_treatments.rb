class RemoveVideoUrlFromTreatments < ActiveRecord::Migration[5.1]
  def change
    remove_column :treatments, :video_url, :string
  end
end
