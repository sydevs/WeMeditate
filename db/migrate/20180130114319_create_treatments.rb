class CreateTreatments < ActiveRecord::Migration[5.1]
  def change
    create_table :treatments do |t|
      t.string :video_url
      t.integer :order
    end

    reversible do |dir|
      dir.up do
        Treatment.create_translation_table!({
          name: { type: :string, null: false },
          slug: { type: :string, null: false },
          excerpt: { type: :text, null: false },
          content: { type: :text },
        })
      end

      dir.down do
        Treatment.drop_translation_table!
      end
    end
  end
end
