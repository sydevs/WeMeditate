class ChangeContentDefaultToString < ActiveRecord::Migration[5.2]
  def change
    change_column_default :article_translations, :content, from: {}, to: nil
    change_column_default :static_page_translations, :content, from: {}, to: nil
    change_column_default :subtle_system_node_translations, :content, from: {}, to: nil
  end
end
