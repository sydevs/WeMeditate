class CreateArticleContents < ActiveRecord::Migration[5.1]
  def change
    create_table :article_contents do |t|
      t.string :header
      t.string :text
      t.column :type, :integer, default: 0
      t.json :options

      t.belongs_to :article, foreign_key: true
    end
  end
end
