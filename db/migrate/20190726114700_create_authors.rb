class CreateAuthors < ActiveRecord::Migration[5.2]
  def change
    create_table :authors do |t|
      t.string :name
      t.integer :years_meditating
      t.jsonb :image
      t.belongs_to :user
      t.string :original_locale, limit: 2, null: false
    end

    reversible do |dir|
      dir.up do
        Author.create_translation_table!({
          title: :string,
          description: :text,
        })
      end

      dir.down do
        Author.drop_translation_table!
      end
    end

    add_belongs_to :articles, :author
  end
end
