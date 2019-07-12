class AddPublishedFlag < ActiveRecord::Migration[5.2]
  def change
    %i[articles static_pages subtle_system_nodes].each do |table|
      remove_column table, :published_at, :datetime
    end

    add_column :article_translations, :published_at, :datetime

    %i[
      article meditation treatment track
      category goal_filter mood_filter instrument_filter
    ].each do |table| 
      add_column "#{table}_translations", :published, :boolean, default: false
    end

    reversible do |dir|
      dir.up do
        DurationFilter.create_translation_table! published: :boolean
      end

      dir.down do
        Post.drop_translation_table!
      end
    end
  end
end
