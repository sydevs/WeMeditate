class CreateCities < ActiveRecord::Migration[5.1]
  def change
    create_table :cities do |t|
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.string :banner, null: false

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        City.create_translation_table!({
          name: { type: :string, null: false },
          slug: { type: :string, null: false }
        })
      end

      dir.down do
        City.drop_translation_table!
      end
    end

    remove_reference :sections, :article, foreign_key: true
    add_reference :sections, :page, polymorphic: true, index: true
  end
end
