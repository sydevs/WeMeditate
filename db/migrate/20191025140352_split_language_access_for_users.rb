class SplitLanguageAccessForUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :languages, :languages_access
    add_column :users, :languages_known, :string, array: true, null: false, default: []
    add_index :users, :languages_known, using: 'gin'
    User.update_all("languages_access = languages_known")
  end
end
