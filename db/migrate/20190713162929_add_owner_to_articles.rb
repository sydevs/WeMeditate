class AddOwnerToArticles < ActiveRecord::Migration[5.2]
  def change
    add_reference :articles, :owner
  end
end
