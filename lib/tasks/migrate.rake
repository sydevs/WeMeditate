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

  desc 'Migrate custom pages to promo pages'
  task custom_pages: :environment do |_, args|
    pages = StaticPage.where.not(role: StaticPage::ROLES.values)
    puts "Migrating #{pages.count} custom pages"

    pages.in_batches.each_record do |r|
      next unless r[:slug].present?

      if PromoPage.friendly.find(r[:slug]).present?
        puts "Skipping page \"#{r.name}\" with slug conflict \"#{r[:slug]}\" (#{r.original_locale})"
      else
        puts "Creating page: \"#{r.name}\""
        PromoPage.create!({
          name: r.name,
          slug: r[:slug],
          state: r.state,
          published_at: r.published_at,
          draft: r.draft,
          content: r.content,
          locale: r.original_locale,
        })
      end
    end
  end

  desc 'Migrate custom pages to promo pages'
  task cleanup_custom_pages: :environment do |_, args|
    pages = StaticPage.where.not(role: StaticPage::ROLES.values)
    puts "Destroying #{pages.count} custom pages"
    pages.destroy_all
    puts "Destroyed #{pages.count} custom pages"
  end
end
