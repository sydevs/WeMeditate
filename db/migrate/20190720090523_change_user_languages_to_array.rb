class ChangeUserLanguagesToArray < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :languages, :string
    add_column :users, :languages, :string, array: true, null: false, default: []
    add_index :users, :languages, using: 'gin'
  end
end
