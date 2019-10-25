class AddCoordinatesToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :latitude, :float
    add_column :articles, :longitude, :float
  end
end
