class RemoveBannerFromArticles < ActiveRecord::Migration[5.2]
  def change
    remove_column :article_translations, :banner_id, :integer
  end
end
