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
          [Article, StaticPage, PromoPage, Stream, SubtleSystemNode, Treatment].each do |model|
            puts "Migrating #{model} for #{Globalize.locale}"
            model.in_batches.each_record do |r|
              r.migrate_content!
            rescue StandardError => e
              puts "#{e}\e[31m\r\n#{e.backtrace.join("\n")}\e[0m"
            end
          end
        end
      end
    end
  end
end
