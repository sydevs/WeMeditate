class RemoveNameFromAuthor < ActiveRecord::Migration[6.0]
  def up
    rename_column :authors, :name, :global_name
    Author.add_translation_fields! name: :string

    Author.find_each do |author|
      author.translations.update_all(name: author.global_name)
    end

    remove_column :authors, :global_name
  end

  def down
    add_column :authors, :global_name, :string

    Author.find_each do |author|
      author.update!(global_name: author.translations.pluck(:name).first)
    end

    remove_column :author_translations, :name
    rename_column :authors, :global_name, :name
  end
end
