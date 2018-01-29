class CreateStaticPages < ActiveRecord::Migration[5.1]
  def change
    create_table :static_pages do |t|
      t.integer :role, null: false

      t.timestamps
    end

    add_index :static_pages, :role, unique: true

    reversible do |dir|
      dir.up do
        StaticPage.create_translation_table!({
          title: { type: :string, null: false },
          slug: { type: :string, null: false }
        })
      end

      dir.down do
        StaticPage.drop_translation_table!
      end
    end
  end
end
