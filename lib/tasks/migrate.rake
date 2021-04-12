namespace :migrate do
  desc "Migrate content json to the new format"
  task :content => :environment do
    [Article, StaticPage, Stream, SubtleSystemNode, Treatment].each do |model|
      model.in_batches do |record|
        record.migrate_content!
      end
    end
  end
end