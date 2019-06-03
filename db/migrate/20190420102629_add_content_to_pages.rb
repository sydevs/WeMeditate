class AddContentToPages < ActiveRecord::Migration[5.2]

  def change
    add_column :article_translations, :content, :jsonb, default: {}
    add_column :static_page_translations, :content, :jsonb, default: {}
    add_column :subtle_system_node_translations, :content, :jsonb, default: {}
    remove_column :treatment_translations, :content, :text
    add_column :treatment_translations, :content, :jsonb, default: {}
  end

end
