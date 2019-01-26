class AddDrafts < ActiveRecord::Migration[5.2]
  def change
    add_column :static_page_translations, :draft, :json
    add_column :article_translations, :draft, :json
    add_column :city_translations, :draft, :json
    add_column :section_translations, :draft, :json
  end
end
