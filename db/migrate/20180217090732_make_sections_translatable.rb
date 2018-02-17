class MakeSectionsTranslatable < ActiveRecord::Migration[5.1]
  def change
    remove_column :sections, :parameters, :jsonb
    remove_column :sections, :images, :jsonb
    remove_column :sections, :language, :integer, default: 0, null: false

    reversible do |dir|
      dir.up do
        Section.create_translation_table! \
          label: :string,
          title: :string,
          subtitle: :string,
          sidetext: :string,
          text: :text,
          quote: :text,
          credit: :string,
          url: :string,
          action: :string,
          image: :jsonb,
          video: :jsonb
      end

      dir.down do
        Section.drop_translation_table!
      end
    end
  end
end
