class AddState < ActiveRecord::Migration[5.2]
  def change
    [Article, StaticPage, SubtleSystemNode, Treatment, Meditation, Author].each do |model|
      add_column model::Translation.table_name, :state, :integer, default: 0
    end

    reversible do |dir|
      dir.up do
        Author::Translation.find_each do |record|
          record.update! published_at: DateTime.now
        end

        [StaticPage, SubtleSystemNode].each do |model|
          model::Translation.update_all state: model.states[:published]
        end

        [Article, Treatment, Meditation, Author].each do |model|
          model::Translation.find_each do |record|
            record.update! state: record.published_at? || record.published? ? model.states[:published] : model.states[:in_progress]
          end
        end
      end

      dir.down do
        [Article, Treatment, Meditation].each do |model|
          model::Translation.find_each do |record|
            record.update! published: record.published?
          end
        end
      end
    end

    [Article, Treatment, Meditation].each do |model|
      remove_column model::Translation.table_name, :published, :boolean
    end
  end
end
