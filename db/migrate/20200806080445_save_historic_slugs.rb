class SaveHistoricSlugs < ActiveRecord::Migration[6.0]

  def change
    [StaticPage, Article, SubtleSystemNode, Meditation, Stream, Treatment].each do |model|
      model.find_each.select(&:save)
    end
  end

end
