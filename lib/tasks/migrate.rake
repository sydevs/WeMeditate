namespace :migrate do
  desc 'Migrate content json to the new format'
  task :content, %i[model id] => :environment do |_, args|
    puts "Migrating content for #{I18n.available_locales.inspect}"

    I18n.available_locales.each do |locale|
      Globalize.with_locale(locale) do
        if args.model && args.id
          record = args.model.classify.constantize.find(args.id)
          record.migrate_content!
        else
          [Article, StaticPage, Stream, SubtleSystemNode, Treatment].each do |model|
            puts "Migrating #{model} for #{Globalize.locale}"
            model.in_batches.each_record(&:migrate_content!)
          end
        end
      end
    end
  end
end
