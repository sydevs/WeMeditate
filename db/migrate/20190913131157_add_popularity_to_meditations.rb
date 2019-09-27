class AddPopularityToMeditations < ActiveRecord::Migration[5.2]
  def up
    add_column :meditation_translations, :popularity, :float, null: false, default: 0
    connection.execute('UPDATE meditation_translations SET popularity = views')
  end

  def down
    remove_column :meditation_translations, :popularity
  end
end
